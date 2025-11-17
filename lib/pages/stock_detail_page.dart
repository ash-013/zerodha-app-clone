import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import '../models/stock.dart';
import '../providers/stock_provider.dart';
import '../providers/portfolio_provider.dart';
import '../models/order.dart';

class StockDetailPage extends StatefulWidget {
  final Stock stock;

  const StockDetailPage({super.key, required this.stock});

  @override
  State<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  final NumberFormat _priceFormat = NumberFormat('#,##0.00');
  final NumberFormat _percentFormat = NumberFormat('+#,##0.00;-#,##0.00');
  String _selectedTimeframe = '1D';

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    final currentStock = stockProvider.getStock(widget.stock.symbol) ?? widget.stock;
    final isPositive = currentStock.change >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentStock.symbol,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              currentStock.exchange,
              style: TextStyle(
                color:
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.star_border,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _priceFormat.format(currentStock.lastPrice),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              isPositive
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: changeColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_percentFormat.format(currentStock.change)} (${_percentFormat.format(currentStock.changePercent)}%)',
                              style: TextStyle(
                                color: changeColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Chart
                  _buildChart(context, currentStock),
                  // Timeframe selector
                  _buildTimeframeSelector(context),
                  // Stats
                  _buildStatsSection(context, currentStock),
                  // About
                  _buildAboutSection(context, currentStock),
                ],
              ),
            ),
          ),
          // Buy/Sell buttons
          _buildActionButtons(context, currentStock),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, Stock stock) {
    // Generate mock chart data
    final data = _generateChartData(stock);

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: data,
              isCurved: true,
              color: stock.change >= 0 ? Colors.green : Colors.red,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: (stock.change >= 0 ? Colors.green : Colors.red)
                    .withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateChartData(Stock stock) {
    final random = Random();
    final basePrice = stock.close;
    final data = <FlSpot>[];

    for (int i = 0; i < 50; i++) {
      final variance = (random.nextDouble() - 0.5) * (basePrice * 0.02);
      final price = basePrice + variance + (stock.lastPrice - basePrice) * (i / 50);
      data.add(FlSpot(i.toDouble(), price));
    }

    return data;
  }

  Widget _buildTimeframeSelector(BuildContext context) {
    final timeframes = ['1D', '1W', '1M', '3M', '1Y', 'ALL'];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: timeframes.length,
        itemBuilder: (context, index) {
          final timeframe = timeframes[index];
          final isSelected = timeframe == _selectedTimeframe;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(timeframe),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedTimeframe = timeframe;
                });
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, Stock stock) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stats',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow(context, 'Open', _priceFormat.format(stock.open)),
          _buildStatRow(context, 'High', _priceFormat.format(stock.high)),
          _buildStatRow(context, 'Low', _priceFormat.format(stock.low)),
          _buildStatRow(context, 'Prev. Close', _priceFormat.format(stock.close)),
          _buildStatRow(context, 'Volume',
              '${(stock.volume / 1000000).toStringAsFixed(2)}M'),
          _buildStatRow(context, '52W High',
              _priceFormat.format(stock.weekHigh52)),
          _buildStatRow(context, '52W Low',
              _priceFormat.format(stock.weekLow52)),
          _buildStatRow(
              context, 'P/E Ratio', stock.peRatio.toStringAsFixed(2)),
          _buildStatRow(context, 'Market Cap',
              '₹${(stock.marketCap / 10000000).toStringAsFixed(0)}Cr'),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSecondary
                  .withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, Stock stock) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            stock.name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This is a demo stock in the Kite by Zerodha clone app. Real stock data and trading functionality would be integrated via actual APIs in production.',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSecondary
                  .withOpacity(0.7),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Stock stock) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _showOrderDialog(context, stock, OrderSide.buy);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'BUY',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _showOrderDialog(context, stock, OrderSide.sell);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'SELL',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDialog(BuildContext context, Stock stock, OrderSide side) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderBottomSheet(
        stock: stock,
        side: side,
      ),
    );
  }
}

// Order bottom sheet widget
class OrderBottomSheet extends StatefulWidget {
  final Stock stock;
  final OrderSide side;

  const OrderBottomSheet({
    super.key,
    required this.stock,
    required this.side,
  });

  @override
  State<OrderBottomSheet> createState() => _OrderBottomSheetState();
}

class _OrderBottomSheetState extends State<OrderBottomSheet> {
  OrderType _orderType = OrderType.market;
  ProductType _productType = ProductType.cnc;
  int _quantity = 1;
  double? _price;
  final TextEditingController _quantityController = TextEditingController(text: '1');
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _price = widget.stock.lastPrice;
    _priceController.text = widget.stock.lastPrice.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final portfolioProvider = Provider.of<PortfolioProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.stock.symbol,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.side.toString().split('.').last.toUpperCase(),
                    style: TextStyle(
                      color: widget.side == OrderSide.buy
                          ? Colors.blue
                          : Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Quantity
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            decoration: InputDecoration(
              labelText: 'Quantity',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.7),
              ),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.3),
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _quantity = int.tryParse(value) ?? 1;
              });
            },
          ),
          const SizedBox(height: 16),
          // Price (for limit orders)
          if (_orderType == OrderType.limit)
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              decoration: InputDecoration(
                labelText: 'Price',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.7),
                ),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.3),
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _price = double.tryParse(value);
                });
              },
            ),
          if (_orderType == OrderType.limit) const SizedBox(height: 16),
          // Order type
          DropdownButtonFormField<OrderType>(
            value: _orderType,
            dropdownColor: Theme.of(context).colorScheme.secondary,
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            decoration: InputDecoration(
              labelText: 'Order Type',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.7),
              ),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.3),
                ),
              ),
            ),
            items: OrderType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.toString().split('.').last.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _orderType = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          // Product type
          DropdownButtonFormField<ProductType>(
            value: _productType,
            dropdownColor: Theme.of(context).colorScheme.secondary,
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            decoration: InputDecoration(
              labelText: 'Product',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.7),
              ),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.3),
                ),
              ),
            ),
            items: ProductType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.toString().split('.').last.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _productType = value!;
              });
            },
          ),
          const SizedBox(height: 24),
          // Place order button
          ElevatedButton(
            onPressed: () {
              final order = Order.create(
                symbol: widget.stock.symbol,
                name: widget.stock.name,
                exchange: widget.stock.exchange,
                orderType: _orderType,
                side: widget.side,
                quantity: _quantity,
                price: _orderType == OrderType.market ? null : _price,
                product: _productType,
              );

              portfolioProvider.placeOrder(order);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Order placed: ${widget.side.toString().split('.').last.toUpperCase()} $_quantity ${widget.stock.symbol}',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.side == OrderSide.buy ? Colors.blue : Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Place ${widget.side.toString().split('.').last.toUpperCase()} Order',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
