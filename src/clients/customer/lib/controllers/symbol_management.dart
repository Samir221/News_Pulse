import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SymbolManagement extends ChangeNotifier {
  final FirebaseFirestore firestore;
  final String userID;
  List<String> symbols = [];

  SymbolManagement({required this.firestore, required this.userID});

  Future<void> initialize(String watchlistName) async {
    final userCollection = firestore.collection('users');
    final watchlist =
        userCollection.doc(userID).collection('watchlists').doc(watchlistName);

    final snapshot = await watchlist.get();
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data != null) {
      final symbolsList = data['symbols'] ?? [];
      initializeSymbols(symbolsList);
    }
  }

  Future<void> addToWatchlist(String symbol, String watchlistName, {Function? onSymbolAdded}) async {
    final userCollection = firestore.collection('users');
    final watchlist =
        userCollection.doc(userID).collection('watchlists').doc(watchlistName);

    await watchlist.update({
      'symbols': FieldValue.arrayUnion([symbol])
    });

    notifyListeners();
        if (onSymbolAdded != null) {
        onSymbolAdded(); // Call the callback function after the symbol has been added
    }
  }

  Future<void> removeFromWatchlist(String symbol, String watchlistName) async {
    final userCollection = firestore.collection('users');
    final watchlist =
        userCollection.doc(userID).collection('watchlists').doc(watchlistName);

    await watchlist.update({
      'symbols': FieldValue.arrayRemove([symbol])
    });

    // Update the local symbols list after removing from Firestore
    symbols.remove(symbol);
    notifyListeners();
  }

  void initializeSymbols(List<dynamic> symbolsList) {
    if (symbolsList != null && symbolsList.isNotEmpty) {
      if (!listEquals(symbols, symbolsList.cast<String>())) {
        symbols = symbolsList.cast<String>();
        notifyListeners();
      }
    } else {
      symbols = [];
      notifyListeners();
    }
  }
}
