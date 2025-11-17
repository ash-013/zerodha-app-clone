enum OrderType { market, limit, sl, slm } // Market, Limit, Stop Loss, Stop Loss Market

enum OrderSide { buy, sell }

enum OrderStatus { pending, completed, cancelled, rejected, open }

class Order {
  final String orderId;
  final String symbol;
  final String name;
  final String exchange;
  final OrderType orderType;
  final OrderSide side;
  final int quantity;
  final int filledQuantity;
  final double? price; // null for market orders
  final double? triggerPrice; // for SL orders
  final double? averagePrice; // filled price
  final OrderStatus status;
  final ProductType product;
  final DateTime orderTime;
  final DateTime? fillTime;
  final String? message; // rejection reason or other messages

  Order({
    required this.orderId,
    required this.symbol,
    required this.name,
    required this.exchange,
    required this.orderType,
    required this.side,
    required this.quantity,
    required this.filledQuantity,
    this.price,
    this.triggerPrice,
    this.averagePrice,
    required this.status,
    required this.product,
    required this.orderTime,
    this.fillTime,
    this.message,
  });

  // Factory for creating a new order
  factory Order.create({
    required String symbol,
    required String name,
    required String exchange,
    required OrderType orderType,
    required OrderSide side,
    required int quantity,
    double? price,
    double? triggerPrice,
    required ProductType product,
  }) {
    return Order(
      orderId: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      symbol: symbol,
      name: name,
      exchange: exchange,
      orderType: orderType,
      side: side,
      quantity: quantity,
      filledQuantity: 0,
      price: price,
      triggerPrice: triggerPrice,
      status: OrderStatus.pending,
      product: product,
      orderTime: DateTime.now(),
    );
  }

  // Copy with method for updating order status
  Order copyWith({
    String? orderId,
    String? symbol,
    String? name,
    String? exchange,
    OrderType? orderType,
    OrderSide? side,
    int? quantity,
    int? filledQuantity,
    double? price,
    double? triggerPrice,
    double? averagePrice,
    OrderStatus? status,
    ProductType? product,
    DateTime? orderTime,
    DateTime? fillTime,
    String? message,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      exchange: exchange ?? this.exchange,
      orderType: orderType ?? this.orderType,
      side: side ?? this.side,
      quantity: quantity ?? this.quantity,
      filledQuantity: filledQuantity ?? this.filledQuantity,
      price: price ?? this.price,
      triggerPrice: triggerPrice ?? this.triggerPrice,
      averagePrice: averagePrice ?? this.averagePrice,
      status: status ?? this.status,
      product: product ?? this.product,
      orderTime: orderTime ?? this.orderTime,
      fillTime: fillTime ?? this.fillTime,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'symbol': symbol,
      'name': name,
      'exchange': exchange,
      'orderType': orderType.toString(),
      'side': side.toString(),
      'quantity': quantity,
      'filledQuantity': filledQuantity,
      'price': price,
      'triggerPrice': triggerPrice,
      'averagePrice': averagePrice,
      'status': status.toString(),
      'product': product.toString(),
      'orderTime': orderTime.toIso8601String(),
      'fillTime': fillTime?.toIso8601String(),
      'message': message,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      symbol: json['symbol'],
      name: json['name'],
      exchange: json['exchange'],
      orderType: OrderType.values.firstWhere(
        (e) => e.toString() == json['orderType'],
      ),
      side: OrderSide.values.firstWhere(
        (e) => e.toString() == json['side'],
      ),
      quantity: json['quantity'],
      filledQuantity: json['filledQuantity'],
      price: json['price']?.toDouble(),
      triggerPrice: json['triggerPrice']?.toDouble(),
      averagePrice: json['averagePrice']?.toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      product: ProductType.values.firstWhere(
        (e) => e.toString() == json['product'],
      ),
      orderTime: DateTime.parse(json['orderTime']),
      fillTime:
          json['fillTime'] != null ? DateTime.parse(json['fillTime']) : null,
      message: json['message'],
    );
  }
}

// Re-export ProductType from position.dart
enum ProductType { mis, cnc, nrml }
