# Kite by Zerodha - Clone App

A complete Flutter clone of the Kite trading app by Zerodha with real-time stock price tickers and comprehensive trading features.

## Features

### 📊 Watchlist with Real-Time Stock Tickers
- 7 customizable watchlists
- Real-time stock price updates (simulated every 2 seconds)
- Live P&L tracking with color-coded gains/losses
- Search and add stocks functionality
- Volume and price change indicators

### 💼 Portfolio Management
- **Holdings Page**: View all your stock holdings with:
  - Current value and investment value
  - Real-time P&L calculation
  - Percentage returns
  - Average price and LTP (Last Traded Price)

- **Positions Page**: Track intraday positions with:
  - Real-time P&L for open positions
  - Long/Short position indicators
  - MIS/CNC/NRML product types
  - Quick exit functionality

### 📝 Order Management
- **Orders Page**: Complete order history with:
  - Order status (Pending, Open, Completed, Cancelled, Rejected)
  - Order details (Symbol, Quantity, Price, Type)
  - Cancel pending orders
  - Order timestamps

- **Order Placement**: Full-featured order dialog with:
  - Market and Limit orders
  - Stop Loss (SL) and Stop Loss Market (SLM) orders
  - Product types: CNC (Delivery), MIS (Intraday), NRML (Normal)
  - Custom quantity and price inputs

### 💰 Funds Management
- Available cash display
- Used and available margin tracking
- Opening balance and collateral
- Payin/Payout history
- Add funds functionality

### 📈 Stock Detail Page
- Real-time price updates
- Interactive price charts with multiple timeframes (1D, 1W, 1M, 3M, 1Y, ALL)
- Comprehensive stock statistics:
  - Open, High, Low, Previous Close
  - Volume and Average Volume
  - 52-week High/Low
  - P/E Ratio and Market Cap
- Buy/Sell quick action buttons

### 👤 Profile & Apps
- User profile management
- Quick access to trading tools:
  - Console (Account management)
  - Coin (Mutual funds)
  - Streak (Algo trading)
  - Sensibull (Options trading)
  - Varsity (Learn trading)
- Settings and support
- Reports and referrals

## Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **Charts**: FL Chart
- **Real-time Updates**: Mock simulation with Timer-based price updates
- **Formatting**: intl package for currency and number formatting
- **HTTP**: http package (ready for API integration)

## Project Structure

```
lib/
├── main.dart                          # App entry point with providers
├── models/                            # Data models
│   ├── stock.dart                    # Stock model
│   ├── holding.dart                  # Holding model
│   ├── position.dart                 # Position model
│   ├── order.dart                    # Order model
│   └── fund.dart                     # Fund model
├── providers/                         # State management
│   ├── stock_provider.dart           # Stock data and watchlists
│   └── portfolio_provider.dart       # Portfolio, orders, positions
├── services/                          # Business logic
│   └── mock_stock_service.dart       # Mock stock data with real-time updates
├── pages/                             # UI screens
│   ├── home_page.dart                # Main page with bottom navigation
│   ├── watchlist_page.dart           # Watchlist with real-time tickers
│   ├── holdings_page.dart            # Portfolio holdings
│   ├── orders_page.dart              # Order history
│   ├── positions_page.dart           # Intraday positions
│   ├── funds_page.dart               # Funds and margin
│   ├── profile_page.dart             # Profile and apps
│   ├── stock_detail_page.dart        # Stock details and charts
│   └── search_page_watchlist.dart    # Search stocks
└── theme/                             # App themes
    ├── darkTheme.dart                # Dark theme (active)
    └── lightTheme.dart               # Light theme
```

## Installation

### Prerequisites
- Flutter SDK (3.5.3 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- An emulator or physical device

### Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd zerodha-app-clone
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Features in Detail

### Real-Time Stock Price Updates

The app simulates real-time stock price updates using a Timer-based system:
- Prices update every 2 seconds
- Random price fluctuations within realistic ranges (-0.5% to +0.5%)
- Automatic P&L recalculation for holdings and positions
- Live chart updates on stock detail page

### Mock Data

The app includes mock data for:
- **15 Indian stocks** including: RELIANCE, TCS, INFY, HDFCBANK, ICICIBANK, SBIN, BHARTIARTL, ITC, LT, WIPRO, TATAMOTORS, TATASTEEL, AXISBANK, SUNPHARMA, MARUTI
- **5 Holdings** with realistic P&L
- **2 Intraday Positions**
- **3 Orders** (completed and pending)
- **Fund details** with ₹5,00,000 opening balance

### Navigation

The app features a bottom navigation bar with 5 main sections:
1. **Watchlist** - Stock tickers and watchlists
2. **Orders** - Order history and positions
3. **Holdings** - Portfolio with P&L
4. **Funds** - Account balance and margins
5. **Apps** - Profile and trading tools

## Customization

### Adding More Stocks

Edit `lib/services/mock_stock_service.dart` and add stocks to the `_createMockStocks()` method:

```dart
'NEWSYMBOL': Stock(
  symbol: 'NEWSYMBOL',
  name: 'New Stock Name',
  exchange: 'NSE',
  lastPrice: 100.00,
  open: 99.50,
  high: 101.00,
  low: 99.00,
  close: 99.80,
  change: 0.20,
  changePercent: 0.20,
  volume: 1000000,
  averageVolume: 900000,
  marketCap: 10000000000,
  peRatio: 25.0,
  weekHigh52: 120.00,
  weekLow52: 80.00,
  lastUpdateTime: DateTime.now(),
),
```

### Modifying Watchlists

Edit `lib/providers/stock_provider.dart` to modify the default watchlists:

```dart
final Map<String, List<String>> _watchlists = {
  'Watchlist 1': ['RELIANCE', 'TCS', 'INFY', 'HDFCBANK'],
  'Watchlist 2': ['SBIN', 'BHARTIARTL', 'ITC'],
  // Add or modify watchlists
};
```

### Changing Update Frequency

Modify the timer duration in `lib/services/mock_stock_service.dart`:

```dart
_priceUpdateTimer = Timer.periodic(const Duration(seconds: 2), (_) {
  _updatePrices(); // Change to Duration(seconds: 1) for faster updates
});
```

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Known Limitations

This is a demo/clone app with the following limitations:
- Uses mock data instead of real market APIs
- No authentication or user accounts
- No actual trading capabilities
- Simulated real-time updates (not connected to live market feeds)
- No data persistence (resets on app restart)
- Charts use mock historical data

## Future Enhancements

Potential improvements for production:
- [ ] Integration with real market data APIs (e.g., NSE, BSE, Alpha Vantage)
- [ ] User authentication and authorization (Firebase Auth)
- [ ] Data persistence with local database (SQLite/Hive)
- [ ] WebSocket connection for real-time data
- [ ] Advanced charting with technical indicators (RSI, MACD, etc.)
- [ ] Market depth and order book
- [ ] GTT (Good Till Triggered) orders
- [ ] Options chain
- [ ] Mutual funds integration
- [ ] Push notifications for price alerts
- [ ] News feed integration
- [ ] Screener functionality
- [ ] Backtest strategies

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is for educational purposes only. Kite and Zerodha are trademarks of Zerodha Broking Ltd.

## Disclaimer

This is a clone/demo application created for educational purposes. It is not affiliated with, endorsed by, or connected to Zerodha or any financial institution. Do not use this app for actual trading. Always use official, regulated trading platforms for real investments.

## Screenshots

### Watchlist Page
- Real-time stock tickers with live price updates
- Color-coded gains (green) and losses (red)
- Volume information

### Stock Detail Page
- Interactive charts with multiple timeframes
- Comprehensive stock statistics
- Buy/Sell action buttons

### Holdings Page
- Current portfolio value
- Total P&L with percentage returns
- Individual stock holdings with real-time updates

### Orders & Positions
- Complete order history
- Active positions with real-time P&L
- Order placement with multiple order types

### Funds Page
- Available cash and margin
- Beautiful gradient card design
- Margin usage visualization

## Support

For issues, questions, or suggestions, please open an issue on GitHub.

---

**Built with ❤️ using Flutter**

**Version**: 1.0.0
**Last Updated**: November 2025
