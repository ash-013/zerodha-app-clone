import 'package:flutter/foundation.dart';
import '../models/holding.dart';
import '../models/position.dart';
import '../models/order.dart';
import '../models/fund.dart';

class PortfolioProvider with ChangeNotifier {
  // Holdings
  List<Holding> _holdings = [];

  // Positions
  List<Position> _positions = [];

  // Orders
  List<Order> _orders = [];

  // Funds
  Fund _fund = Fund(
    availableCash: 500000.00,
    usedMargin: 150000.00,
    availableMargin: 350000.00,
    openingBalance: 500000.00,
    collateral: 0.00,
    payin: 0.00,
    payout: 0.00,
  );

  List<Holding> get holdings => _holdings;
  List<Position> get positions => _positions;
  List<Order> get orders => _orders;
  Fund get fund => _fund;

  // Get total portfolio value
  double get totalHoldingsValue {
    return _holdings.fold(0.0, (sum, holding) => sum + holding.currentValue);
  }

  // Get total P&L from holdings
  double get totalHoldingsPnL {
    return _holdings.fold(0.0, (sum, holding) => sum + holding.pnl);
  }

  // Get total P&L from positions
  double get totalPositionsPnL {
    return _positions.fold(0.0, (sum, position) => sum + position.pnl);
  }

  // Get total day P&L
  double get totalDayPnL {
    final holdingsDayPnL =
        _holdings.fold(0.0, (sum, holding) => sum + holding.dayChange);
    return holdingsDayPnL + totalPositionsPnL;
  }

  PortfolioProvider() {
    _initializeMockData();
  }

  // Initialize with mock portfolio data
  void _initializeMockData() {
    _holdings = [
      Holding.fromStockAndQuantity(
        symbol: 'RELIANCE',
        name: 'Reliance Industries Ltd',
        exchange: 'NSE',
        quantity: 50,
        averagePrice: 2400.00,
        lastPrice: 2456.75,
      ),
      Holding.fromStockAndQuantity(
        symbol: 'TCS',
        name: 'Tata Consultancy Services Ltd',
        exchange: 'NSE',
        quantity: 30,
        averagePrice: 3600.00,
        lastPrice: 3642.50,
      ),
      Holding.fromStockAndQuantity(
        symbol: 'INFY',
        name: 'Infosys Ltd',
        exchange: 'NSE',
        quantity: 100,
        averagePrice: 1420.00,
        lastPrice: 1456.30,
      ),
      Holding.fromStockAndQuantity(
        symbol: 'HDFCBANK',
        name: 'HDFC Bank Ltd',
        exchange: 'NSE',
        quantity: 75,
        averagePrice: 1650.00,
        lastPrice: 1678.90,
      ),
      Holding.fromStockAndQuantity(
        symbol: 'ICICIBANK',
        name: 'ICICI Bank Ltd',
        exchange: 'NSE',
        quantity: 120,
        averagePrice: 1050.00,
        lastPrice: 1089.45,
      ),
    ];

    _positions = [
      Position.create(
        symbol: 'SBIN',
        name: 'State Bank of India',
        exchange: 'NSE',
        quantity: 200,
        averagePrice: 595.00,
        lastPrice: 598.75,
        type: PositionType.long,
        product: ProductType.mis,
      ),
      Position.create(
        symbol: 'BHARTIARTL',
        name: 'Bharti Airtel Ltd',
        exchange: 'NSE',
        quantity: 50,
        averagePrice: 1450.00,
        lastPrice: 1456.20,
        type: PositionType.long,
        product: ProductType.mis,
      ),
    ];

    _orders = [
      Order.create(
        symbol: 'WIPRO',
        name: 'Wipro Ltd',
        exchange: 'NSE',
        orderType: OrderType.limit,
        side: OrderSide.buy,
        quantity: 100,
        price: 455.00,
        product: ProductType.cnc,
      ).copyWith(
        status: OrderStatus.completed,
        filledQuantity: 100,
        averagePrice: 455.00,
        fillTime: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Order.create(
        symbol: 'TATAMOTORS',
        name: 'Tata Motors Ltd',
        exchange: 'NSE',
        orderType: OrderType.market,
        side: OrderSide.buy,
        quantity: 50,
        product: ProductType.mis,
      ).copyWith(
        status: OrderStatus.completed,
        filledQuantity: 50,
        averagePrice: 785.00,
        fillTime: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      Order.create(
        symbol: 'MARUTI',
        name: 'Maruti Suzuki India Ltd',
        exchange: 'NSE',
        orderType: OrderType.limit,
        side: OrderSide.sell,
        quantity: 10,
        price: 10250.00,
        product: ProductType.cnc,
      ).copyWith(
        status: OrderStatus.open,
      ),
    ];
  }

  // Update holding prices
  void updateHoldingPrices(Map<String, double> prices) {
    for (int i = 0; i < _holdings.length; i++) {
      final holding = _holdings[i];
      if (prices.containsKey(holding.symbol)) {
        _holdings[i] = holding.updateWithPrice(prices[holding.symbol]!);
      }
    }
    notifyListeners();
  }

  // Update position prices
  void updatePositionPrices(Map<String, double> prices) {
    for (int i = 0; i < _positions.length; i++) {
      final position = _positions[i];
      if (prices.containsKey(position.symbol)) {
        _positions[i] = position.updateWithPrice(prices[position.symbol]!);
      }
    }
    notifyListeners();
  }

  // Place a new order
  void placeOrder(Order order) {
    _orders.insert(0, order);

    // Simulate order execution after a delay
    Future.delayed(const Duration(seconds: 2), () {
      _executeOrder(order.orderId);
    });

    notifyListeners();
  }

  // Execute an order (mock)
  void _executeOrder(String orderId) {
    final orderIndex = _orders.indexWhere((o) => o.orderId == orderId);
    if (orderIndex != -1) {
      final order = _orders[orderIndex];
      _orders[orderIndex] = order.copyWith(
        status: OrderStatus.completed,
        filledQuantity: order.quantity,
        averagePrice: order.price ?? order.price,
        fillTime: DateTime.now(),
      );

      // Add to holdings or positions based on product type
      if (order.product == ProductType.cnc && order.side == OrderSide.buy) {
        _addToHoldings(order);
      } else if (order.product == ProductType.mis) {
        _addToPositions(order);
      }

      notifyListeners();
    }
  }

  // Add to holdings
  void _addToHoldings(Order order) {
    final existingIndex =
        _holdings.indexWhere((h) => h.symbol == order.symbol);
    if (existingIndex != -1) {
      // Update existing holding
      final existing = _holdings[existingIndex];
      final newQuantity = existing.quantity + order.filledQuantity;
      final newAveragePrice =
          ((existing.averagePrice * existing.quantity) +
                  (order.averagePrice! * order.filledQuantity)) /
              newQuantity;

      _holdings[existingIndex] = Holding.fromStockAndQuantity(
        symbol: order.symbol,
        name: order.name,
        exchange: order.exchange,
        quantity: newQuantity,
        averagePrice: newAveragePrice,
        lastPrice: order.averagePrice!,
      );
    } else {
      // Add new holding
      _holdings.add(
        Holding.fromStockAndQuantity(
          symbol: order.symbol,
          name: order.name,
          exchange: order.exchange,
          quantity: order.filledQuantity,
          averagePrice: order.averagePrice!,
          lastPrice: order.averagePrice!,
        ),
      );
    }
  }

  // Add to positions
  void _addToPositions(Order order) {
    _positions.add(
      Position.create(
        symbol: order.symbol,
        name: order.name,
        exchange: order.exchange,
        quantity: order.filledQuantity,
        averagePrice: order.averagePrice!,
        lastPrice: order.averagePrice!,
        type: order.side == OrderSide.buy
            ? PositionType.long
            : PositionType.short,
        product: order.product,
      ),
    );
  }

  // Cancel an order
  void cancelOrder(String orderId) {
    final orderIndex = _orders.indexWhere((o) => o.orderId == orderId);
    if (orderIndex != -1) {
      _orders[orderIndex] = _orders[orderIndex].copyWith(
        status: OrderStatus.cancelled,
      );
      notifyListeners();
    }
  }

  // Exit a position
  void exitPosition(String symbol) {
    _positions.removeWhere((p) => p.symbol == symbol);
    notifyListeners();
  }
}
