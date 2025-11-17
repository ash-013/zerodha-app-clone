import 'dart:async';
import 'dart:math';
import '../models/stock.dart';

class MockStockService {
  static final MockStockService _instance = MockStockService._internal();
  factory MockStockService() => _instance;
  MockStockService._internal();

  final Random _random = Random();
  Timer? _priceUpdateTimer;
  final Map<String, Stock> _stocks = {};
  final StreamController<Map<String, Stock>> _stockUpdateController =
      StreamController<Map<String, Stock>>.broadcast();

  Stream<Map<String, Stock>> get stockUpdates => _stockUpdateController.stream;

  // Initialize with mock stock data
  void initialize() {
    _stocks.clear();
    _stocks.addAll(_createMockStocks());
    _startPriceUpdates();
  }

  // Create mock Indian stocks
  Map<String, Stock> _createMockStocks() {
    final now = DateTime.now();
    return {
      'RELIANCE': Stock(
        symbol: 'RELIANCE',
        name: 'Reliance Industries Ltd',
        exchange: 'NSE',
        lastPrice: 2456.75,
        open: 2450.00,
        high: 2470.50,
        low: 2445.20,
        close: 2455.00,
        change: 1.75,
        changePercent: 0.07,
        volume: 5234567,
        averageVolume: 4500000,
        marketCap: 16600000000000,
        peRatio: 28.5,
        weekHigh52: 2856.00,
        weekLow52: 2150.00,
        lastUpdateTime: now,
      ),
      'TCS': Stock(
        symbol: 'TCS',
        name: 'Tata Consultancy Services Ltd',
        exchange: 'NSE',
        lastPrice: 3642.50,
        open: 3650.00,
        high: 3665.00,
        low: 3635.00,
        close: 3645.00,
        change: -2.50,
        changePercent: -0.07,
        volume: 1234567,
        averageVolume: 1100000,
        marketCap: 13300000000000,
        peRatio: 31.2,
        weekHigh52: 4043.00,
        weekLow52: 3200.00,
        lastUpdateTime: now,
      ),
      'INFY': Stock(
        symbol: 'INFY',
        name: 'Infosys Ltd',
        exchange: 'NSE',
        lastPrice: 1456.30,
        open: 1460.00,
        high: 1468.50,
        low: 1452.00,
        close: 1458.00,
        change: -1.70,
        changePercent: -0.12,
        volume: 3456789,
        averageVolume: 3200000,
        marketCap: 6100000000000,
        peRatio: 26.8,
        weekHigh52: 1720.00,
        weekLow52: 1350.00,
        lastUpdateTime: now,
      ),
      'HDFCBANK': Stock(
        symbol: 'HDFCBANK',
        name: 'HDFC Bank Ltd',
        exchange: 'NSE',
        lastPrice: 1678.90,
        open: 1675.00,
        high: 1685.00,
        low: 1672.00,
        close: 1676.00,
        change: 2.90,
        changePercent: 0.17,
        volume: 4567890,
        averageVolume: 4200000,
        marketCap: 12800000000000,
        peRatio: 19.5,
        weekHigh52: 1820.00,
        weekLow52: 1460.00,
        lastUpdateTime: now,
      ),
      'ICICIBANK': Stock(
        symbol: 'ICICIBANK',
        name: 'ICICI Bank Ltd',
        exchange: 'NSE',
        lastPrice: 1089.45,
        open: 1085.00,
        high: 1095.00,
        low: 1082.00,
        close: 1087.00,
        change: 2.45,
        changePercent: 0.23,
        volume: 6789012,
        averageVolume: 6000000,
        marketCap: 7600000000000,
        peRatio: 17.8,
        weekHigh52: 1180.00,
        weekLow52: 890.00,
        lastUpdateTime: now,
      ),
      'SBIN': Stock(
        symbol: 'SBIN',
        name: 'State Bank of India',
        exchange: 'NSE',
        lastPrice: 598.75,
        open: 595.00,
        high: 602.50,
        low: 593.00,
        close: 597.00,
        change: 1.75,
        changePercent: 0.29,
        volume: 8901234,
        averageVolume: 8500000,
        marketCap: 5400000000000,
        peRatio: 14.2,
        weekHigh52: 720.00,
        weekLow52: 510.00,
        lastUpdateTime: now,
      ),
      'BHARTIARTL': Stock(
        symbol: 'BHARTIARTL',
        name: 'Bharti Airtel Ltd',
        exchange: 'NSE',
        lastPrice: 1456.20,
        open: 1450.00,
        high: 1462.00,
        low: 1448.00,
        close: 1454.00,
        change: 2.20,
        changePercent: 0.15,
        volume: 2345678,
        averageVolume: 2100000,
        marketCap: 8200000000000,
        peRatio: 45.6,
        weekHigh52: 1598.00,
        weekLow52: 1120.00,
        lastUpdateTime: now,
      ),
      'ITC': Stock(
        symbol: 'ITC',
        name: 'ITC Ltd',
        exchange: 'NSE',
        lastPrice: 423.65,
        open: 422.00,
        high: 426.50,
        low: 421.00,
        close: 423.00,
        change: 0.65,
        changePercent: 0.15,
        volume: 5678901,
        averageVolume: 5200000,
        marketCap: 5300000000000,
        peRatio: 27.5,
        weekHigh52: 498.00,
        weekLow52: 380.00,
        lastUpdateTime: now,
      ),
      'LT': Stock(
        symbol: 'LT',
        name: 'Larsen & Toubro Ltd',
        exchange: 'NSE',
        lastPrice: 3456.80,
        open: 3450.00,
        high: 3468.00,
        low: 3445.00,
        close: 3455.00,
        change: 1.80,
        changePercent: 0.05,
        volume: 1234567,
        averageVolume: 1100000,
        marketCap: 4800000000000,
        peRatio: 32.4,
        weekHigh52: 3850.00,
        weekLow52: 2950.00,
        lastUpdateTime: now,
      ),
      'WIPRO': Stock(
        symbol: 'WIPRO',
        name: 'Wipro Ltd',
        exchange: 'NSE',
        lastPrice: 456.90,
        open: 455.00,
        high: 459.50,
        low: 454.00,
        close: 456.00,
        change: 0.90,
        changePercent: 0.20,
        volume: 3456789,
        averageVolume: 3200000,
        marketCap: 2500000000000,
        peRatio: 24.1,
        weekHigh52: 520.00,
        weekLow52: 390.00,
        lastUpdateTime: now,
      ),
      'TATAMOTORS': Stock(
        symbol: 'TATAMOTORS',
        name: 'Tata Motors Ltd',
        exchange: 'NSE',
        lastPrice: 789.45,
        open: 785.00,
        high: 795.00,
        low: 782.00,
        close: 788.00,
        change: 1.45,
        changePercent: 0.18,
        volume: 7890123,
        averageVolume: 7500000,
        marketCap: 2800000000000,
        peRatio: 18.7,
        weekHigh52: 925.00,
        weekLow52: 580.00,
        lastUpdateTime: now,
      ),
      'TATASTEEL': Stock(
        symbol: 'TATASTEEL',
        name: 'Tata Steel Ltd',
        exchange: 'NSE',
        lastPrice: 123.45,
        open: 122.00,
        high: 125.50,
        low: 121.50,
        close: 123.00,
        change: 0.45,
        changePercent: 0.37,
        volume: 9012345,
        averageVolume: 8800000,
        marketCap: 1500000000000,
        peRatio: 15.3,
        weekHigh52: 168.00,
        weekLow52: 105.00,
        lastUpdateTime: now,
      ),
      'AXISBANK': Stock(
        symbol: 'AXISBANK',
        name: 'Axis Bank Ltd',
        exchange: 'NSE',
        lastPrice: 1089.90,
        open: 1085.00,
        high: 1095.00,
        low: 1082.00,
        close: 1088.00,
        change: 1.90,
        changePercent: 0.17,
        volume: 4567890,
        averageVolume: 4300000,
        marketCap: 3400000000000,
        peRatio: 16.8,
        weekHigh52: 1250.00,
        weekLow52: 890.00,
        lastUpdateTime: now,
      ),
      'SUNPHARMA': Stock(
        symbol: 'SUNPHARMA',
        name: 'Sun Pharmaceutical Industries Ltd',
        exchange: 'NSE',
        lastPrice: 1567.80,
        open: 1565.00,
        high: 1575.00,
        low: 1562.00,
        close: 1566.00,
        change: 1.80,
        changePercent: 0.11,
        volume: 2345678,
        averageVolume: 2100000,
        marketCap: 3800000000000,
        peRatio: 38.2,
        weekHigh52: 1720.00,
        weekLow52: 1280.00,
        lastUpdateTime: now,
      ),
      'MARUTI': Stock(
        symbol: 'MARUTI',
        name: 'Maruti Suzuki India Ltd',
        exchange: 'NSE',
        lastPrice: 10234.50,
        open: 10200.00,
        high: 10268.00,
        low: 10195.00,
        close: 10230.00,
        change: 4.50,
        changePercent: 0.04,
        volume: 234567,
        averageVolume: 220000,
        marketCap: 3100000000000,
        peRatio: 28.9,
        weekHigh52: 12500.00,
        weekLow52: 8950.00,
        lastUpdateTime: now,
      ),
    };
  }

  // Start simulating real-time price updates
  void _startPriceUpdates() {
    _priceUpdateTimer?.cancel();
    _priceUpdateTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _updatePrices();
    });
  }

  // Update stock prices with random fluctuations
  void _updatePrices() {
    final now = DateTime.now();
    _stocks.forEach((symbol, stock) {
      // Generate random price change (-0.5% to +0.5%)
      final changePercent = (_random.nextDouble() - 0.5) * 0.01;
      final priceChange = stock.lastPrice * changePercent;
      final newPrice = stock.lastPrice + priceChange;

      // Update high/low
      final newHigh = max(stock.high, newPrice);
      final newLow = min(stock.low, newPrice);

      // Calculate change from close
      final totalChange = newPrice - stock.close;
      final totalChangePercent = (totalChange / stock.close) * 100;

      // Update volume
      final volumeChange = _random.nextInt(10000);

      _stocks[symbol] = stock.copyWith(
        lastPrice: newPrice,
        high: newHigh,
        low: newLow,
        change: totalChange,
        changePercent: totalChangePercent,
        volume: stock.volume + volumeChange,
        lastUpdateTime: now,
      );
    });

    // Broadcast updated stocks
    _stockUpdateController.add(Map.from(_stocks));
  }

  // Get all stocks
  Map<String, Stock> getAllStocks() => Map.from(_stocks);

  // Get stock by symbol
  Stock? getStock(String symbol) => _stocks[symbol];

  // Search stocks
  List<Stock> searchStocks(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _stocks.values
        .where((stock) =>
            stock.symbol.toLowerCase().contains(lowercaseQuery) ||
            stock.name.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  // Stop price updates
  void dispose() {
    _priceUpdateTimer?.cancel();
    _stockUpdateController.close();
  }
}
