import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newspulse_app/views/symbol_search_screen.dart';
import 'package:newspulse_app/controllers/symbol_management.dart';
import 'package:newspulse_app/controllers/price_fetcher.dart';
import 'package:provider/provider.dart';
import 'package:newspulse_ui/newspulse_ui.dart';

class WatchlistView extends StatefulWidget {
  final String userID;
  final String userName;
  final String defaultWatchlist;

  const WatchlistView({
    required this.userID,
    required this.userName,
    required this.defaultWatchlist,
  });

  @override
  _WatchlistViewState createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  SymbolManagement? symbolManager;
  late PriceFetcher priceFetcher;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      initializeData();
      initialized = true;
    }
  }

  Future<void> initializeData() async {
    final firestore = FirebaseFirestore.instance;
    symbolManager =
        SymbolManagement(firestore: firestore, userID: widget.userID);
    priceFetcher = PriceFetcher();
    await symbolManager!.initialize(widget.defaultWatchlist);
    await fetchData();

    // Fetch prices initially and every 45 seconds
    startPriceFetching();
  }

  Future<void> fetchData() async {
    if (symbolManager != null) {
      await priceFetcher.updatePrices(symbolManager!.symbols, () {
        if (mounted) {
          //setState(() {});
        }
      });
    }
  }

  Future<void> startPriceFetching() async {
    await fetchData();
    Future.delayed(const Duration(seconds: 45), startPriceFetching);
  }

  @override
  void dispose() {
    super.dispose();
    stopPriceFetching();
  }

  void stopPriceFetching() {
    // Implement logic to stop fetching prices
  }

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final userCollection = firestore.collection('users');
    final watchlist = userCollection
        .doc(widget.userID)
        .collection('watchlists')
        .doc(widget.defaultWatchlist);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SymbolManagement>.value(value: symbolManager!),
        ChangeNotifierProvider<PriceFetcher>.value(value: priceFetcher),
      ],
      child: StreamBuilder<DocumentSnapshot>(
        stream: watchlist.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>?;
            if (data != null) {
              final symbols = data['symbols'] ?? [];
              symbolManager!.initializeSymbols(symbols);
            }
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          //fetchData();
          return Consumer2<SymbolManagement, PriceFetcher>(
            builder: (context, symbolManager, priceFetcher, child) {
              final symbols = symbolManager.symbols;
              final prices = priceFetcher.priceList;

              return Scaffold(
                appBar: AppBar(
                  title: Text(widget.defaultWatchlist),
                  backgroundColor: kcDarkBlueColor
                ),
                body: WatchlistViewBody(
                  symbols: symbols,
                  prices: prices,
                  onDismissed: (symbol) async {
                    await symbolManager.removeFromWatchlist(
                        symbol, widget.defaultWatchlist);
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: kcDarkBlueColor,
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SymbolSearchScreen(
                          userID: widget.userID,
                          defaultWatchlist: widget.defaultWatchlist,
                          addToWatchlist: (symbol, watchlistName) {
                            symbolManager.addToWatchlist(symbol, watchlistName, onSymbolAdded: fetchData);
                          },
                          symbolManager: symbolManager,
                          priceFetcher: priceFetcher,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class WatchlistViewBody extends StatelessWidget {
  final List<String> symbols;
  final Map<String, dynamic> prices;
  final Function(String) onDismissed;

  WatchlistViewBody({
    required this.symbols,
    required this.prices,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: symbols.length,
      itemBuilder: (context, index) {
        final symbol = symbols[index];
        final price = prices[symbol] ?? 'N/A';

        return Dismissible(
          key: Key(symbol),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) async {
            await onDismissed(symbol);
          },
          background: Container(color: Colors.red),
          child: ListTile(
            title: Text(symbol),
            subtitle: Text('Price: $price'),
          ),
        );
      },
    );
  }
}
