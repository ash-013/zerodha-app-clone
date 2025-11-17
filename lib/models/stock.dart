class Stock {
  final String symbol;
  final String name;
  final String exchange; // NSE, BSE, etc.
  double lastPrice;
  double open;
  double high;
  double low;
  double close;
  double change;
  double changePercent;
  int volume;
  int averageVolume;
  double marketCap;
  double peRatio;
  double weekHigh52;
  double weekLow52;
  DateTime lastUpdateTime;

  Stock({
    required this.symbol,
    required this.name,
    required this.exchange,
    required this.lastPrice,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.change,
    required this.changePercent,
    required this.volume,
    required this.averageVolume,
    required this.marketCap,
    required this.peRatio,
    required this.weekHigh52,
    required this.weekLow52,
    required this.lastUpdateTime,
  });

  // Copy with method for updating stock values
  Stock copyWith({
    String? symbol,
    String? name,
    String? exchange,
    double? lastPrice,
    double? open,
    double? high,
    double? low,
    double? close,
    double? change,
    double? changePercent,
    int? volume,
    int? averageVolume,
    double? marketCap,
    double? peRatio,
    double? weekHigh52,
    double? weekLow52,
    DateTime? lastUpdateTime,
  }) {
    return Stock(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      exchange: exchange ?? this.exchange,
      lastPrice: lastPrice ?? this.lastPrice,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      change: change ?? this.change,
      changePercent: changePercent ?? this.changePercent,
      volume: volume ?? this.volume,
      averageVolume: averageVolume ?? this.averageVolume,
      marketCap: marketCap ?? this.marketCap,
      peRatio: peRatio ?? this.peRatio,
      weekHigh52: weekHigh52 ?? this.weekHigh52,
      weekLow52: weekLow52 ?? this.weekLow52,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'exchange': exchange,
      'lastPrice': lastPrice,
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'change': change,
      'changePercent': changePercent,
      'volume': volume,
      'averageVolume': averageVolume,
      'marketCap': marketCap,
      'peRatio': peRatio,
      'weekHigh52': weekHigh52,
      'weekLow52': weekLow52,
      'lastUpdateTime': lastUpdateTime.toIso8601String(),
    };
  }

  // Create from JSON
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'],
      name: json['name'],
      exchange: json['exchange'],
      lastPrice: json['lastPrice'].toDouble(),
      open: json['open'].toDouble(),
      high: json['high'].toDouble(),
      low: json['low'].toDouble(),
      close: json['close'].toDouble(),
      change: json['change'].toDouble(),
      changePercent: json['changePercent'].toDouble(),
      volume: json['volume'],
      averageVolume: json['averageVolume'],
      marketCap: json['marketCap'].toDouble(),
      peRatio: json['peRatio'].toDouble(),
      weekHigh52: json['weekHigh52'].toDouble(),
      weekLow52: json['weekLow52'].toDouble(),
      lastUpdateTime: DateTime.parse(json['lastUpdateTime']),
    );
  }
}
