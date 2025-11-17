import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/portfolio_provider.dart';

class FundsPage extends StatelessWidget {
  const FundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolioProvider = Provider.of<PortfolioProvider>(context);
    final fund = portfolioProvider.fund;
    final NumberFormat currencyFormat = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 2,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Funds',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              // Add funds dialog
              _showAddFundsDialog(context);
            },
            icon: const Icon(Icons.add, color: Colors.blue),
            label: const Text(
              'Add funds',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Available cash card
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available cash',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormat.format(fund.availableCash),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Used margin',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currencyFormat.format(fund.usedMargin),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Available margin',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currencyFormat.format(fund.availableMargin),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Details section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    'Opening balance',
                    currencyFormat.format(fund.openingBalance),
                    false,
                  ),
                  _buildDivider(context),
                  _buildDetailRow(
                    context,
                    'Payin',
                    currencyFormat.format(fund.payin),
                    false,
                  ),
                  _buildDivider(context),
                  _buildDetailRow(
                    context,
                    'Payout',
                    currencyFormat.format(fund.payout),
                    false,
                  ),
                  _buildDivider(context),
                  _buildDetailRow(
                    context,
                    'Collateral',
                    currencyFormat.format(fund.collateral),
                    false,
                  ),
                  _buildDivider(context),
                  _buildDetailRow(
                    context,
                    'Total balance',
                    currencyFormat.format(fund.totalBalance),
                    true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Margin section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Margin details',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total margin',
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
                              currencyFormat.format(fund.totalMargin),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSecondary,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Used',
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
                              '${((fund.usedMargin / fund.totalMargin) * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSecondary,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: fund.usedMargin / fund.totalMargin,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .onSecondary
                        .withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                    minHeight: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Info card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Add funds instantly via UPI, Net Banking, or other payment methods',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, String label, String value, bool isBold) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSecondary
                  .withOpacity(isBold ? 1.0 : 0.7),
              fontSize: 16,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.1),
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  void _showAddFundsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          'Add Funds',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        content: Text(
          'This is a demo app. In a real app, you would be able to add funds via UPI, Net Banking, or other payment methods.',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
