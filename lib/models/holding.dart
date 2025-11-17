class Holding {
  final String symbol;
  final String name;
  final String exchange;
  final int quantity;
  final double averagePrice;
  final double lastPrice;
  final double currentValue;
  final double investmentValue;
  final double pnl;
  final double pnlPercent;
  final double dayChange;
  final double dayChangePercent;

  Holding({
    required this.symbol,
    required this.name,
    required this.exchange,
    required this.quantity,
    required this.averagePrice,
    required this.lastPrice,
    required this.currentValue,
    required this.investmentValue,
    required this.pnl,
    required this.pnlPercent,
    required this.dayChange,
    required this.dayChangePercent,
  });

  // Factory constructor to create from stock and purchase details
  factory Holding.fromStockAndQuantity({
    required String symbol,
    required String name,
    required String exchange,
    required int quantity,
    required double averagePrice,
    required double lastPrice,
  }) {
    final currentValue = quantity * lastPrice;
    final investmentValue = quantity * averagePrice;
    final pnl = currentValue - investmentValue;
    final pnlPercent = (pnl / investmentValue) * 100;
    final dayChange = quantity * (lastPrice - averagePrice);
    final dayChangePercent = ((lastPrice - averagePrice) / averagePrice) * 100;

    return Holding(
      symbol: symbol,
      name: name,
      exchange: exchange,
      quantity: quantity,
      averagePrice: averagePrice,
      lastPrice: lastPrice,
      currentValue: currentValue,
      investmentValue: investmentValue,
      pnl: pnl,
      pnlPercent: pnlPercent,
      dayChange: dayChange,
      dayChangePercent: dayChangePercent,
    );
  }

  // Update with new last price
  Holding updateWithPrice(double newPrice) {
    return Holding.fromStockAndQuantity(
      symbol: symbol,
      name: name,
      exchange: exchange,
      quantity: quantity,
      averagePrice: averagePrice,
      lastPrice: newPrice,
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
      'currentValue': currentValue,
      'investmentValue': investmentValue,
      'pnl': pnl,
      'pnlPercent': pnlPercent,
      'dayChange': dayChange,
      'dayChangePercent': dayChangePercent,
    };
  }

  factory Holding.fromJson(Map<String, dynamic> json) {
    return Holding(
      symbol: json['symbol'],
      name: json['name'],
      exchange: json['exchange'],
      quantity: json['quantity'],
      averagePrice: json['averagePrice'].toDouble(),
      lastPrice: json['lastPrice'].toDouble(),
      currentValue: json['currentValue'].toDouble(),
      investmentValue: json['investmentValue'].toDouble(),
      pnl: json['pnl'].toDouble(),
      pnlPercent: json['pnlPercent'].toDouble(),
      dayChange: json['dayChange'].toDouble(),
      dayChangePercent: json['dayChangePercent'].toDouble(),
    );
  }
}
