import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_holding_page_clone/pages/watchlist_page.dart';
import 'package:flutter_holding_page_clone/pages/search_page_watchlist.dart';
import 'package:flutter_holding_page_clone/pages/home_page.dart';
import 'package:flutter_holding_page_clone/pages/stock_detail_page.dart';
import 'package:flutter_holding_page_clone/theme/darkTheme.dart';
import 'package:flutter_holding_page_clone/theme/lightTheme.dart';
import 'package:flutter_holding_page_clone/providers/stock_provider.dart';
import 'package:flutter_holding_page_clone/providers/portfolio_provider.dart';
import 'package:flutter_holding_page_clone/models/stock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StockProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kite by Zerodha',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark, // Force dark theme for testing
        home: HomePage(),
        routes: {
          '/search': (context) => SearchPageWatchlist(),
          '/home': (context) => HomePage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/stock-detail') {
            final stock = settings.arguments as Stock;
            return MaterialPageRoute(
              builder: (context) => StockDetailPage(stock: stock),
            );
          }
          return null;
        },
      ),
    );
  }
}
