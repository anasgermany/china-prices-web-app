# 🛍️ China Prices Web App

A modern Flutter Web application for comparing prices across Chinese e-commerce platforms with a beautiful, responsive UI and dynamic product loading.

## ✨ Features

- **🔄 Dynamic Products**: Fresh products loaded every time you visit or refresh
- **🎨 Modern UI/UX**: Built with Flutter 3 and Material 3 design principles
- **📱 Responsive Design**: Works perfectly on desktop, tablet, and mobile
- **🔍 Smart Search**: Real-time search with debouncing for better performance
- **❤️ Favorites System**: Save and manage your favorite products
- **🏷️ Category Filtering**: Browse products by different categories
- **🔗 Affiliate Links**: Direct links to AliExpress with proper tracking
- **⚡ Fast Performance**: Optimized for web with efficient data loading

## 🚀 Getting Started

### Prerequisites

- Flutter 3.10.0 or higher
- Dart 3.0.0 or higher
- Chrome browser (for web development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/china-prices-web-app.git
   cd china-prices-web-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run -d chrome --web-port 8080
   ```

4. **Open in browser**
   Navigate to `http://localhost:8080`

## 🏗️ Project Structure

```
lib/
├── constants/          # App constants and configuration
├── models/            # Data models
├── screens/           # UI screens
├── services/          # Business logic and API services
├── widgets/           # Reusable UI components
└── main.dart          # App entry point
```

## 🎯 Key Components

### Screens
- **Home Screen**: Main product browsing with search and categories
- **Product Detail**: Beautiful product page with modern design
- **Favorites**: Manage your saved products
- **Search**: Advanced search functionality

### Services
- **AppProvider**: State management and business logic
- **ApiService**: Product data fetching
- **WebUrlService**: Web-specific URL handling
- **WebStorageService**: Local storage for web

## 🔧 Configuration

### Categories
Edit `lib/constants/app_constants.dart` to customize:
- Category names
- JSON data sources
- App colors and themes

### Product Data
The app loads products from JSON files. You can:
- Add new categories
- Update product sources
- Customize data structure

## 🚀 Deployment

### Firebase Hosting (Recommended)
1. Install Firebase CLI
2. Run `firebase login`
3. Run `firebase deploy`

### Other Platforms
- Netlify
- Vercel
- GitHub Pages

## 🎨 Customization

### Colors
Update the color scheme in `lib/constants/app_constants.dart`:
```dart
class AppConstants {
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  // ... more colors
}
```

### Typography
The app uses Google Fonts (Poppins). Customize in `lib/main.dart`:
```dart
textTheme: GoogleFonts.poppinsTextTheme(),
```

## 🔍 Search Functionality

The search system includes:
- **Real-time search** with debouncing
- **Multi-word matching** for better results
- **Category filtering** integration
- **Search history** (coming soon)

## ❤️ Favorites System

- **Local storage** for web compatibility
- **Add/Remove** products easily
- **Persistent data** across sessions
- **Quick access** from home screen

## 📱 Responsive Design

The app automatically adapts to different screen sizes:
- **Desktop**: 4-column grid layout
- **Tablet**: 3-column grid layout  
- **Mobile**: 1-2 column grid layout

## 🚀 Performance Features

- **Lazy loading** of product images
- **Efficient state management** with Provider
- **Optimized search** with debouncing
- **Smart caching** of product data

## 🐛 Troubleshooting

### Common Issues

1. **Products not loading**
   - Check internet connection
   - Verify JSON URLs in constants
   - Check browser console for errors

2. **Search not working**
   - Ensure search controller is properly initialized
   - Check AppProvider state management
   - Verify search method calls

3. **Build errors**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Check Flutter version compatibility

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for design guidelines
- Google Fonts for beautiful typography
- The Flutter community for inspiration

## 📞 Support

If you have any questions or need help:
- Open an issue on GitHub
- Check the documentation
- Review the code examples

---

**Made with ❤️ using Flutter Web**
