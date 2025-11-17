import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/stock_provider.dart';
import '../models/stock.dart';

class WatchListPage extends StatefulWidget {
  const WatchListPage({super.key});

  @override
  State<WatchListPage> createState() => _WatchListPageState();
}

class _WatchListPageState extends State<WatchListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NumberFormat _priceFormat = NumberFormat('#,##0.00');
  final NumberFormat _percentFormat = NumberFormat('+#,##0.00;-#,##0.00');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openSearch(BuildContext context) {
    Navigator.of(context).pushNamed('/search');
  }

  void _openStockDetail(BuildContext context, Stock stock) {
    Navigator.of(context).pushNamed('/stock-detail', arguments: stock);
  }

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Watchlist',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 30,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
              },
              icon: Icon(Icons.shopping_cart_outlined,
                  color: Theme.of(context).colorScheme.onPrimary)),
          IconButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
              },
              icon: Icon(
                Icons.keyboard_arrow_down_sharp,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 40,
              )),
          const SizedBox(width: 8)
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TabBar - Wrapped in Material to override AppBar's foregroundColor
          Material(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerColor: Colors.transparent,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
                insets: const EdgeInsets.only(right: 50),
              ),
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.values[1],
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              labelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'Watchlist 1'),
                Tab(text: 'Watchlist 2'),
                Tab(text: 'Watchlist 3'),
                Tab(text: 'Watchlist 4'),
                Tab(text: 'Watchlist 5'),
                Tab(text: 'Watchlist 6'),
                Tab(text: 'Watchlist 7'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Search & Add Box
          Padding(
            padding: const EdgeInsets.all(12),
            child: Material(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  HapticFeedback.vibrate();
                  _openSearch(context);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Icon(Icons.search,
                            size: 28,
                            color: Theme.of(context).colorScheme.onPrimary),
                        const SizedBox(width: 12),
                        Text(
                          'Search & add',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                        const Spacer(),
                        Text(
                          '10/100',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(width: 8),
                        const VerticalDivider(
                          color: Colors.white24,
                          thickness: 2,
                          indent: 5,
                          endIndent: 5,
                          width: 23,
                        ),
                        IconButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              // BottomSheet for adjustments
                            },
                            icon: Icon(Icons.tune,
                                size: 28,
                                color:
                                    Theme.of(context).colorScheme.onSecondary)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // TabBarView for content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(7, (index) {
                final watchlistName = 'Watchlist ${index + 1}';
                final stocks = stockProvider.getWatchlistStocks(watchlistName);

                if (stocks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          size: 64,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No stocks in this watchlist',
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
                  );
                }

                return ListView.builder(
                  itemCount: stocks.length,
                  itemBuilder: (context, stockIndex) {
                    final stock = stocks[stockIndex];
                    return _buildStockTile(context, stock);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockTile(BuildContext context, Stock stock) {
    final isPositive = stock.change >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;

    return InkWell(
      onTap: () => _openStockDetail(context, stock),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Stock symbol and name
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stock.symbol,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    stock.exchange,
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
            // Volume/quantity info
            Expanded(
              flex: 1,
              child: Text(
                '${(stock.volume / 1000).toStringAsFixed(0)}K',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
            ),
            // Price and change
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _priceFormat.format(stock.lastPrice),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${_percentFormat.format(stock.change)} ',
                        style: TextStyle(
                          color: changeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '(${_percentFormat.format(stock.changePercent)}%)',
                        style: TextStyle(
                          color: changeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
