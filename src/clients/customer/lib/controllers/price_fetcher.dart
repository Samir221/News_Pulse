// price_fetcher.dart

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PriceFetcher with ChangeNotifier {
  Map<String, String> priceList = {};

Future<void> updatePrices(
      List<String> symbols, Function() onPricesUpdated) async {
    if (symbols == null || symbols.isEmpty) {
      print('Symbols list is null or empty');
      return;
    }
    final apiKey = '728883d73a69cfac83c4ba8b7d10f076';
    final apiUrl =
        'https://financialmodelingprep.com/api/v3/quote/${symbols.join(",")}?apikey=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (!(jsonData is List<dynamic>)) {
        print('Error: Invalid response format');
        return;
      }
      final quotes = jsonData as List<dynamic>;
      if (quotes == null) {
        print('Error: Quotes data is null');
        return;
      }
      final newPriceList = <String, String>{};
      for (var quote in quotes) {
        final symbol = quote['symbol']; // change this line
        final price = quote['price'].toString(); // and this line
        newPriceList[symbol] = price;
      }
      priceList = newPriceList;
      notifyListeners(); 
      onPricesUpdated(); // Call the callback function
      //notifyListeners(); 
    } else {
      print('Error: ${response.statusCode}');
    }
}


  Future<String?> getPrice(String symbol) async {
    // Fetch the price asynchronously and return a nullable String
    return priceList[symbol];
  }
}
