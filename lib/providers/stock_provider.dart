import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/stock.dart';
import '../services/mock_stock_service.dart';

class StockProvider with ChangeNotifier {
  final MockStockService _stockService = MockStockService();
  Map<String, Stock> _stocks = {};
  StreamSubscription? _stockUpdateSubscription;

  // Watchlists
  final Map<String, List<String>> _watchlists = {
    'Watchlist 1': ['RELIANCE', 'TCS', 'INFY', 'HDFCBANK', 'ICICIBANK'],
    'Watchlist 2': ['SBIN', 'BHARTIARTL', 'ITC', 'LT'],
    'Watchlist 3': ['WIPRO', 'TATAMOTORS', 'TATASTEEL'],
    'Watchlist 4': ['AXISBANK', 'SUNPHARMA', 'MARUTI'],
    'Watchlist 5': [],
    'Watchlist 6': [],
    'Watchlist 7': [],
  };

  Map<String, Stock> get stocks => _stocks;
  Map<String, List<String>> get watchlists => _watchlists;

  StockProvider() {
    _initialize();
  }

  void _initialize() {
    _stockService.initialize();
    _stocks = _stockService.getAllStocks();

    // Subscribe to stock updates
    _stockUpdateSubscription = _stockService.stockUpdates.listen((updatedStocks) {
      _stocks = updatedStocks;
      notifyListeners();
    });
  }

  // Get stocks for a specific watchlist
  List<Stock> getWatchlistStocks(String watchlistName) {
    final symbols = _watchlists[watchlistName] ?? [];
    return symbols
        .map((symbol) => _stocks[symbol])
        .whereType<Stock>()
        .toList();
  }

  // Add stock to watchlist
  void addToWatchlist(String watchlistName, String symbol) {
    if (_watchlists.containsKey(watchlistName)) {
      if (!_watchlists[watchlistName]!.contains(symbol)) {
        _watchlists[watchlistName]!.add(symbol);
        notifyListeners();
      }
    }
  }

  // Remove stock from watchlist
  void removeFromWatchlist(String watchlistName, String symbol) {
    if (_watchlists.containsKey(watchlistName)) {
      _watchlists[watchlistName]!.remove(symbol);
      notifyListeners();
    }
  }

  // Search stocks
  List<Stock> searchStocks(String query) {
    if (query.isEmpty) return [];
    return _stockService.searchStocks(query);
  }

  // Get stock by symbol
  Stock? getStock(String symbol) {
    return _stocks[symbol];
  }

  @override
  void dispose() {
    _stockUpdateSubscription?.cancel();
    _stockService.dispose();
    super.dispose();
  }
}
