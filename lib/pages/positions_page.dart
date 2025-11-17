import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/portfolio_provider.dart';
import '../providers/stock_provider.dart';
import '../models/position.dart';

class PositionsTab extends StatefulWidget {
  const PositionsTab({super.key});

  @override
  State<PositionsTab> createState() => _PositionsTabState();
}

class _PositionsTabState extends State<PositionsTab> {
  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 2,
  );
  final NumberFormat _percentFormat = NumberFormat('+#,##0.00;-#,##0.00');

  @override
  void initState() {
    super.initState();
    // Update positions with real-time stock prices
    _updatePositionPrices();
  }

  void _updatePositionPrices() {
    final stockProvider = Provider.of<StockProvider>(context, listen: false);
    final portfolioProvider =
        Provider.of<PortfolioProvider>(context, listen: false);

    // Create a map of symbol -> price
    final prices = <String, double>{};
    for (var position in portfolioProvider.positions) {
      final stock = stockProvider.getStock(position.symbol);
      if (stock != null) {
        prices[position.symbol] = stock.lastPrice;
      }
    }

    portfolioProvider.updatePositionPrices(prices);
  }

  @override
  Widget build(BuildContext context) {
    final portfolioProvider = Provider.of<PortfolioProvider>(context);
    final stockProvider = Provider.of<StockProvider>(context);

    // Update prices whenever stocks update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prices = <String, double>{};
      for (var position in portfolioProvider.positions) {
        final stock = stockProvider.getStock(position.symbol);
        if (stock != null) {
          prices[position.symbol] = stock.lastPrice;
        }
      }
      portfolioProvider.updatePositionPrices(prices);
    });

    if (portfolioProvider.positions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline,
              size: 64,
              color:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No positions yet',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Open intraday positions will appear here',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    final totalPnL = portfolioProvider.totalPositionsPnL;
    final isPnLPositive = totalPnL >= 0;

    return Column(
      children: [
        // Summary card
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total P&L (Day)',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSecondary
                      .withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              Text(
                _currencyFormat.format(totalPnL),
                style: TextStyle(
                  color: isPnLPositive ? Colors.green : Colors.red,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Positions list
        Expanded(
          child: ListView.builder(
            itemCount: portfolioProvider.positions.length,
            itemBuilder: (context, index) {
              final position = portfolioProvider.positions[index];
              return _buildPositionTile(context, position, portfolioProvider);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPositionTile(BuildContext context, Position position,
      PortfolioProvider portfolioProvider) {
    final isPnLPositive = position.pnl >= 0;
    final pnlColor = isPnLPositive ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          position.symbol,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: position.type == PositionType.long
                                ? Colors.blue.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            position.type.toString().split('.').last.toUpperCase(),
                            style: TextStyle(
                              color: position.type == PositionType.long
                                  ? Colors.blue
                                  : Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${position.quantity} qty • ${position.product.toString().split('.').last.toUpperCase()}',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _currencyFormat.format(position.pnl),
                    style: TextStyle(
                      color: pnlColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_percentFormat.format(position.pnlPercent)}%',
                    style: TextStyle(
                      color: pnlColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Price details row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Avg. Price',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _currencyFormat.format(position.averagePrice),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'LTP',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _currencyFormat.format(position.lastPrice),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  portfolioProvider.exitPosition(position.symbol);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Exited ${position.symbol}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('EXIT'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
