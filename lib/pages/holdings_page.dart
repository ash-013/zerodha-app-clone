import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/portfolio_provider.dart';
import '../providers/stock_provider.dart';
import '../models/holding.dart';

class HoldingsPage extends StatefulWidget {
  const HoldingsPage({super.key});

  @override
  State<HoldingsPage> createState() => _HoldingsPageState();
}

class _HoldingsPageState extends State<HoldingsPage> {
  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 2,
  );
  final NumberFormat _percentFormat = NumberFormat('+#,##0.00;-#,##0.00');

  @override
  void initState() {
    super.initState();
    // Update holdings with real-time stock prices
    _updateHoldingPrices();
  }

  void _updateHoldingPrices() {
    final stockProvider = Provider.of<StockProvider>(context, listen: false);
    final portfolioProvider =
        Provider.of<PortfolioProvider>(context, listen: false);

    // Create a map of symbol -> price
    final prices = <String, double>{};
    for (var holding in portfolioProvider.holdings) {
      final stock = stockProvider.getStock(holding.symbol);
      if (stock != null) {
        prices[holding.symbol] = stock.lastPrice;
      }
    }

    portfolioProvider.updateHoldingPrices(prices);
  }

  @override
  Widget build(BuildContext context) {
    final portfolioProvider = Provider.of<PortfolioProvider>(context);
    final stockProvider = Provider.of<StockProvider>(context);

    // Update prices whenever stocks update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prices = <String, double>{};
      for (var holding in portfolioProvider.holdings) {
        final stock = stockProvider.getStock(holding.symbol);
        if (stock != null) {
          prices[holding.symbol] = stock.lastPrice;
        }
      }
      portfolioProvider.updateHoldingPrices(prices);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Holdings',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary card
          _buildSummaryCard(context, portfolioProvider),
          const SizedBox(height: 8),
          // Holdings list
          Expanded(
            child: portfolioProvider.holdings.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 64,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No holdings yet',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: portfolioProvider.holdings.length,
                    itemBuilder: (context, index) {
                      final holding = portfolioProvider.holdings[index];
                      return _buildHoldingTile(context, holding);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      BuildContext context, PortfolioProvider portfolioProvider) {
    final totalValue = portfolioProvider.totalHoldingsValue;
    final totalPnL = portfolioProvider.totalHoldingsPnL;
    final isPnLPositive = totalPnL >= 0;

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current value',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSecondary
                          .withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currencyFormat.format(totalValue),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'P&L',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSecondary
                          .withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currencyFormat.format(totalPnL),
                    style: TextStyle(
                      color: isPnLPositive ? Colors.green : Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_percentFormat.format((totalPnL / (totalValue - totalPnL)) * 100)}%',
                    style: TextStyle(
                      color: isPnLPositive ? Colors.green : Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHoldingTile(BuildContext context, Holding holding) {
    final isPnLPositive = holding.pnl >= 0;
    final pnlColor = isPnLPositive ? Colors.green : Colors.red;

    return InkWell(
      onTap: () {
        // Navigate to stock detail
      },
      child: Container(
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
                      Text(
                        holding.symbol,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${holding.quantity} qty',
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
                      _currencyFormat.format(holding.currentValue),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'LTP: ${_currencyFormat.format(holding.lastPrice)}',
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
              ],
            ),
            const SizedBox(height: 12),
            // P&L row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invested',
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
                      _currencyFormat.format(holding.investmentValue),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'P&L',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          _currencyFormat.format(holding.pnl),
                          style: TextStyle(
                            color: pnlColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${_percentFormat.format(holding.pnlPercent)}%)',
                          style: TextStyle(
                            color: pnlColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
