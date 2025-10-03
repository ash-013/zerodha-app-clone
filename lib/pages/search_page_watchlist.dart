import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchPageWatchlist extends StatefulWidget {
  const SearchPageWatchlist({super.key});

  @override
  State<SearchPageWatchlist> createState() => _SearchPageWatchlistState();
}

class _SearchPageWatchlistState extends State<SearchPageWatchlist>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _hasText = _searchController.text.isNotEmpty;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: SafeArea(
            child: Row(
              children: [
                BackButton(color: Theme.of(context).colorScheme.onSurface),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                    ),
                    cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      hintText: 'Search eg: infy, nifty, gold',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      suffixIcon: _hasText
                          ? TextButton(
                              onPressed: () => _searchController.clear(),
                              child: const Text(
                                'Clear',
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              insets: EdgeInsets.zero,
            ),
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorWeight: 1,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            tabs: const [
              Tab(text: '#'),
              Tab(text: 'MF'),
              Tab(text: 'IPO'),
              Tab(text: 'Events'),
              Tab(text: 'Brands'),
              Tab(text: 'ETF'),
              Tab(text: 'G-Sec'),
            ],
          ),
          Divider(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          // ADDED: TabBarView to enable swipe scrolling
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Content for each tab
                _buildSearchResults('#'),
                _buildSearchResults('MF'),
                _buildSearchResults('IPO'),
                _buildSearchResults('Events'),
                _buildSearchResults('Brands'),
                _buildSearchResults('ETF'),
                _buildSearchResults('G-Sec'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build search results for each tab
  Widget _buildSearchResults(String category) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Text(
            'Search results for: $category',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
