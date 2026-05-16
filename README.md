# BestDeal 🛍️

A Flutter price comparison app that searches for products across multiple stores (Amazon, eBay, Walmart, and more) and sorts results by best price.

## Features
- 🔍 Search any product
- 💰 Compare prices across stores
- ⭐ Best deal highlighted at the top
- 🌟 Product ratings and reviews
- 🔗 Direct links to product pages

## Setup Instructions

### 1. Prerequisites
- Install [Flutter](https://flutter.dev/docs/get-started/install)
- Install [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)

### 2. Add Your API Key
1. Sign up at [RapidAPI](https://rapidapi.com)
2. Subscribe to [Real-Time Product Search](https://rapidapi.com/letscrape-6bRBa3QguO5/api/real-time-product-search)
3. Copy your API key
4. Open `lib/services/api_service.dart`
5. Replace `YOUR_RAPIDAPI_KEY_HERE` with your actual key

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Run the App
```bash
flutter run
```

## Project Structure
```
lib/
├── main.dart              # App entry point
├── models/
│   └── product.dart       # Product data model
├── screens/
│   └── home_screen.dart   # Main search screen
├── services/
│   └── api_service.dart   # API calls to RapidAPI
└── widgets/
    └── product_card.dart  # Product display card
```

## Built With
- Flutter & Dart
- RapidAPI Real-Time Product Search
- Material Design 3
