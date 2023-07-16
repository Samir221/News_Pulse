import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newspulse_app/controllers/symbol_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newspulse_app/controllers/price_fetcher.dart';
import 'package:newspulse_ui/newspulse_ui.dart';

class SymbolSearchScreen extends StatefulWidget {
  final String userID;
  final Function(String, String) addToWatchlist;
  final SymbolManagement symbolManager;
  final PriceFetcher priceFetcher; // Add PriceFetcher parameter
  final String defaultWatchlist;

  const SymbolSearchScreen({
    Key? key,
    required this.userID,
    required this.addToWatchlist,
    required this.symbolManager,
    required this.priceFetcher, // Add PriceFetcher parameter
    required this.defaultWatchlist,
  }) : super(key: key);

  @override
  _SymbolSearchScreenState createState() => _SymbolSearchScreenState();
}

class _SymbolSearchScreenState extends State<SymbolSearchScreen> {
  List<SearchResult> _searchResults = [];
  TextEditingController _searchController = TextEditingController();
  late String defaultWatchlist;

  Future<void> searchSymbols(String keywords) async {
    final apiKey = '2NJ8KCYUHOQGCCG1';
    final apiUrl =
        'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$keywords&apikey=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final searchResults = jsonData['bestMatches'] as List<dynamic>;
      setState(() {
        _searchResults = searchResults
            .map((result) => SearchResult.fromJson(result))
            .toList();
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    final firestore = FirebaseFirestore.instance;
    final userCollection = firestore.collection('users');
    final documentId =
        widget.userID; // Assuming documentId is the same as userID
    DocumentReference docRef = userCollection.doc(documentId);
    docRef.get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          defaultWatchlist = data['DefaultWatchlist'] ?? 'Default Watchlist';
          setState(() {});
        }
      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      print('Error getting document: $error');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kcDarkBlueColor,
        title: const Text('Symbol Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Enter symbol',
              ),
              onChanged: (value) {
                searchSymbols(value);
              },
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  return ListTile(
                    title: Text(result.symbol),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(result.name), // Display the name immediately
                        const SizedBox(height: 4.0),
                        FutureBuilder<String?>(
                          future: widget.priceFetcher.getPrice(result.symbol),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('Fetching price...');
                            }
                            if (snapshot.hasData) {
                              final price = snapshot.data!;
                              return Text('Price: $price');
                            }
                            if (snapshot.hasError) {
                              return Text('Error fetching price');
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      print('Selected symbol: ${result.symbol}');
                      widget.addToWatchlist(result.symbol, defaultWatchlist);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResult {
  final String symbol;
  final String name;
  final String type;
  final String region;

  SearchResult({
    required this.symbol,
    required this.name,
    required this.type,
    required this.region,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      symbol: json['1. symbol'],
      name: json['2. name'],
      type: json['3. type'],
      region: json['4. region'],
    );
  }
}
