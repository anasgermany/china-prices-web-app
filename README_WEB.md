# China Prices - Flutter Web App 🌐

A modern, responsive Flutter web application for comparing prices across Chinese e-commerce platforms. Built with Material 3 design principles and optimized for desktop, tablet, and mobile devices.

## ✨ Features

### 🎯 Core Functionality
- **Price Comparison**: Compare products across multiple Chinese e-commerce platforms
- **Category Browsing**: Organized product categories with intuitive navigation
- **Advanced Search**: Powerful search with filters and sorting options
- **Favorites System**: Save and organize your favorite products
- **Search History**: Track your search patterns and get recommendations
- **Responsive Design**: Optimized for all screen sizes and devices

### 🎨 Modern UI/UX
- **Material 3 Design**: Latest Google Material Design principles
- **Responsive Layout**: Adaptive design for desktop, tablet, and mobile
- **Smooth Animations**: Flutter Animate for delightful interactions
- **Google Fonts**: Beautiful typography with Poppins font family
- **Dark/Light Theme**: Automatic theme switching based on system preference

### 🌐 Web-Optimized
- **Progressive Web App (PWA)**: Installable web app with offline capabilities
- **SEO Optimized**: Meta tags and structured data for search engines
- **Fast Loading**: Optimized assets and lazy loading
- **Cross-Browser Support**: Works on all modern browsers
- **Firebase Hosting Ready**: Pre-configured for easy deployment

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Chrome browser (for development)
- Node.js (for Firebase deployment)

### Installation

1. **Clone the repository**:
```bash
git clone <your-repo-url>
cd webchinapricescursor
```

2. **Get dependencies**:
```bash
flutter pub get
```

3. **Run the app**:
```bash
flutter run -d chrome
```

4. **Build for production**:
```bash
flutter build web --release
```

## 🏗️ Project Structure

```
lib/
├── constants/           # App constants and configuration
│   └── app_constants.dart
├── models/             # Data models
├── screens/            # UI screens
├── services/           # Business logic and API services
├── utils/              # Utility classes
│   └── responsive_utils.dart
├── widgets/            # Reusable UI components
├── main.dart           # App entry point
└── routes.dart         # Navigation routing

web/                    # Web-specific files
├── index.html          # Main HTML file
├── manifest.json       # PWA manifest
└── favicon.png         # App icon

firebase.json           # Firebase Hosting configuration
```

## 🎨 Customization

### Colors and Theme
Edit `lib/constants/app_constants.dart` to customize:
```dart
static const Color primaryColor = Color(0xFFFF6B35);
static const Color secondaryColor = Color(0xFF4ECDC4);
static const Color backgroundColor = Color(0xFFF8F9FA);
```

### Responsive Breakpoints
Modify `lib/utils/responsive_utils.dart`:
```dart
static const double mobileBreakpoint = 600.0;
static const double tabletBreakpoint = 900.0;
static const double desktopBreakpoint = 1200.0;
```

### Categories
Update categories in `app_constants.dart`:
```dart
static const List<Map<String, dynamic>> editableCategories = [
  {
    'name': 'Electronics',
    'icon': Icons.devices,
    'imageUrl': 'https://example.com/image.jpg',
    'jsonUrl': 'https://example.com/products.json',
  },
  // Add more categories...
];
```

## 📱 Responsive Design

The app automatically adapts to different screen sizes:

- **Desktop (>1200px)**: Sidebar navigation with large content area
- **Tablet (900-1200px)**: Top navigation bar with medium content
- **Mobile (<900px)**: Bottom navigation with compact layout

### Responsive Utilities
Use `ResponsiveUtils` class for consistent responsive behavior:
```dart
// Get responsive dimensions
final padding = ResponsiveUtils.getResponsivePadding(context);
final fontSize = ResponsiveUtils.getResponsiveFontSize(
  context,
  mobile: 16,
  tablet: 18,
  desktop: 20,
);

// Check screen size
if (ResponsiveUtils.isDesktop(context)) {
  // Desktop-specific code
}
```

## 🌐 Web Features

### PWA Capabilities
- **Installable**: Add to home screen on supported devices
- **Offline Support**: Service worker for offline functionality
- **App-like Experience**: Full-screen mode and native feel

### SEO Optimization
- Meta tags for search engines
- Structured data markup
- Optimized page titles and descriptions
- Social media meta tags

### Performance
- Lazy loading for images
- Optimized asset delivery
- Efficient state management
- Minimal bundle size

## 🔧 Development

### Running in Development Mode
```bash
flutter run -d chrome --web-port 8080
```

### Hot Reload
The app supports hot reload for fast development:
- Save any file to see changes instantly
- Hot restart for major changes
- State preservation during hot reload

### Debugging
- Use Chrome DevTools for web debugging
- Flutter Inspector for widget debugging
- Console logging for debugging

## 📦 Building for Production

### Basic Build
```bash
flutter build web --release
```

### Optimized Build
```bash
flutter build web --release --web-renderer canvaskit
```

### Custom Base Path
```bash
flutter build web --release --base-href "/china-prices/"
```

## 🚀 Deployment

### Firebase Hosting (Recommended)
1. Install Firebase CLI: `npm install -g firebase-tools`
2. Login: `firebase login`
3. Initialize: `firebase init hosting`
4. Build: `flutter build web --release`
5. Deploy: `firebase deploy --only hosting`

### Other Hosting Options
- **Netlify**: Drag and drop `build/web` folder
- **Vercel**: Connect GitHub repository
- **GitHub Pages**: Use GitHub Actions for deployment
- **Custom Server**: Serve `build/web` folder from any web server

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

### Web Testing
- Test on different browsers (Chrome, Firefox, Safari, Edge)
- Test responsive design on various screen sizes
- Test PWA functionality
- Test offline capabilities

## 📊 Performance Monitoring

### Core Web Vitals
- **Largest Contentful Paint (LCP)**: Target < 2.5s
- **First Input Delay (FID)**: Target < 100ms
- **Cumulative Layout Shift (CLS)**: Target < 0.1

### Performance Tools
- Chrome DevTools Performance tab
- Lighthouse audits
- Flutter performance overlay
- Firebase Performance Monitoring

## 🔒 Security

### Best Practices
- HTTPS only deployment
- Input validation and sanitization
- Content Security Policy (CSP)
- Regular dependency updates
- Secure API endpoints

### Security Headers
Configured in `firebase.json`:
- Cache control headers
- Security headers
- CORS configuration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

### Code Style
- Follow Flutter style guide
- Use meaningful variable names
- Add comments for complex logic
- Keep functions small and focused

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for design guidelines
- Google Fonts for beautiful typography
- Firebase team for hosting platform

## 📞 Support

- **Issues**: Create an issue on GitHub
- **Discussions**: Use GitHub Discussions
- **Documentation**: Check Flutter web docs
- **Community**: Join Flutter community forums

---

**Built with ❤️ using Flutter Web**
