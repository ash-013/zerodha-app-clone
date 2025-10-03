import 'package:flutter/material.dart';
import 'package:flutter_holding_page_clone/pages/watchlist_page.dart';
import 'package:flutter_holding_page_clone/pages/search_page_watchlist.dart';
import 'package:flutter_holding_page_clone/theme/darkTheme.dart';
import 'package:flutter_holding_page_clone/theme/lightTheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kite by Zerodha',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark, // Force dark theme for testing
      home: WatchListPage(),
      routes: {
        '/search': (context) => SearchPageWatchlist(),
      },
    );
  }
}
