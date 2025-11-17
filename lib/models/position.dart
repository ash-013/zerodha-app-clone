enum PositionType { long, short }

enum ProductType { mis, cnc, nrml } // MIS: Intraday, CNC: Delivery, NRML: Normal

class Position {
  final String symbol;
  final String name;
  final String exchange;
  final int quantity;
  final double averagePrice;
  final double lastPrice;
  final PositionType type;
  final ProductType product;
  final double pnl;
  final double pnlPercent;
  final DateTime entryTime;

  Position({
    required this.symbol,
    required this.name,
    required this.exchange,
    required this.quantity,
    required this.averagePrice,
    required this.lastPrice,
    required this.type,
    required this.product,
    required this.pnl,
    required this.pnlPercent,
    required this.entryTime,
  });

  // Factory constructor
  factory Position.create({
    required String symbol,
    required String name,
    required String exchange,
    required int quantity,
    required double averagePrice,
    required double lastPrice,
    required PositionType type,
    required ProductType product,
  }) {
    double pnl;
    if (type == PositionType.long) {
      pnl = quantity * (lastPrice - averagePrice);
    } else {
      pnl = quantity * (averagePrice - lastPrice);
    }

    final pnlPercent = (pnl / (quantity * averagePrice)) * 100;

    return Position(
      symbol: symbol,
      name: name,
      exchange: exchange,
      quantity: quantity,
      averagePrice: averagePrice,
      lastPrice: lastPrice,
      type: type,
      product: product,
      pnl: pnl,
      pnlPercent: pnlPercent,
      entryTime: DateTime.now(),
    );
  }

  // Update with new last price
  Position updateWithPrice(double newPrice) {
    return Position.create(
      symbol: symbol,
      name: name,
      exchange: exchange,
      quantity: quantity,
      averagePrice: averagePrice,
      lastPrice: newPrice,
      type: type,
      product: product,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'exchange': exchange,
      'quantity': quantity,
      'averagePrice': averagePrice,
      'lastPrice': lastPrice,
      'type': type.toString(),
      'product': product.toString(),
      'pnl': pnl,
      'pnlPercent': pnlPercent,
      'entryTime': entryTime.toIso8601String(),
    };
  }

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      symbol: json['symbol'],
      name: json['name'],
      exchange: json['exchange'],
      quantity: json['quantity'],
      averagePrice: json['averagePrice'].toDouble(),
      lastPrice: json['lastPrice'].toDouble(),
      type: PositionType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      product: ProductType.values.firstWhere(
        (e) => e.toString() == json['product'],
      ),
      pnl: json['pnl'].toDouble(),
      pnlPercent: json['pnlPercent'].toDouble(),
      entryTime: DateTime.parse(json['entryTime']),
    );
  }
}
