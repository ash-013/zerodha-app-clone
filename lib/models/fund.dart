class Fund {
  final double availableCash;
  final double usedMargin;
  final double availableMargin;
  final double openingBalance;
  final double collateral;
  final double payin;
  final double payout;

  Fund({
    required this.availableCash,
    required this.usedMargin,
    required this.availableMargin,
    required this.openingBalance,
    required this.collateral,
    required this.payin,
    required this.payout,
  });

  double get totalBalance => availableCash + collateral;
  double get totalMargin => availableMargin + usedMargin;

  Fund copyWith({
    double? availableCash,
    double? usedMargin,
    double? availableMargin,
    double? openingBalance,
    double? collateral,
    double? payin,
    double? payout,
  }) {
    return Fund(
      availableCash: availableCash ?? this.availableCash,
      usedMargin: usedMargin ?? this.usedMargin,
      availableMargin: availableMargin ?? this.availableMargin,
      openingBalance: openingBalance ?? this.openingBalance,
      collateral: collateral ?? this.collateral,
      payin: payin ?? this.payin,
      payout: payout ?? this.payout,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availableCash': availableCash,
      'usedMargin': usedMargin,
      'availableMargin': availableMargin,
      'openingBalance': openingBalance,
      'collateral': collateral,
      'payin': payin,
      'payout': payout,
    };
  }

  factory Fund.fromJson(Map<String, dynamic> json) {
    return Fund(
      availableCash: json['availableCash'].toDouble(),
      usedMargin: json['usedMargin'].toDouble(),
      availableMargin: json['availableMargin'].toDouble(),
      openingBalance: json['openingBalance'].toDouble(),
      collateral: json['collateral'].toDouble(),
      payin: json['payin'].toDouble(),
      payout: json['payout'].toDouble(),
    );
  }
}
