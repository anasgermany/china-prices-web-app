# China Prices - Flutter Web App Deployment Guide

## 🚀 Quick Start

### 1. Build the Web App
```bash
# Navigate to your project directory
cd /path/to/your/project

# Get dependencies
flutter pub get

# Build for web
flutter build web --release
```

### 2. Test Locally
```bash
# Serve the built web app locally
flutter run -d chrome --web-port 8080

# Or use any local server
cd build/web
python3 -m http.server 8080
# Then open http://localhost:8080 in your browser
```

## 🌐 Firebase Hosting Deployment

### Prerequisites
1. Install Firebase CLI:
```bash
npm install -g firebase-tools
```

2. Login to Firebase:
```bash
firebase login
```

### Deploy to Firebase Hosting

1. **Initialize Firebase in your project** (first time only):
```bash
firebase init hosting
```
- Select your Firebase project
- Set public directory to: `build/web`
- Configure as single-page app: `Yes`
- Don't overwrite index.html: `No`

2. **Build and Deploy**:
```bash
# Build the web app
flutter build web --release

# Deploy to Firebase
firebase deploy --only hosting
```

3. **Your app will be available at**:
```
https://your-project-id.web.app
https://your-project-id.firebaseapp.com
```

## 🔧 Advanced Build Options

### Production Build with Custom Base Href
```bash
flutter build web --release --base-href "/china-prices/"
```

### Build with Performance Analysis
```bash
flutter build web --release --analyze-size
```

### Build for Specific Web Renderer
```bash
# HTML renderer (better compatibility)
flutter build web --release --web-renderer html

# CanvasKit renderer (better performance)
flutter build web --release --web-renderer canvaskit
```

## 📱 PWA Configuration

The app is configured as a Progressive Web App (PWA) with:
- Service worker support
- App manifest
- Offline capabilities
- Install prompt

### Customize PWA Settings
Edit `web/manifest.json` to modify:
- App name and description
- Theme colors
- Icons
- Display mode

## 🎨 Customization

### Colors and Theme
Edit `lib/constants/app_constants.dart` to customize:
- Primary colors
- Background colors
- Text colors
- UI dimensions

### Responsive Breakpoints
Modify `lib/utils/responsive_utils.dart` to adjust:
- Mobile breakpoint (default: 600px)
- Tablet breakpoint (default: 900px)
- Desktop breakpoint (default: 1200px)

## 🚨 Troubleshooting

### Common Issues

1. **Build fails with dependency errors**:
```bash
flutter clean
flutter pub get
flutter build web
```

2. **Web app not loading**:
- Check browser console for errors
- Verify `web/index.html` exists
- Ensure all assets are properly referenced

3. **Responsive design issues**:
- Test on different screen sizes
- Check `ResponsiveUtils` implementation
- Verify breakpoint values

4. **Firebase deployment fails**:
```bash
firebase logout
firebase login
firebase deploy --only hosting
```

### Performance Optimization

1. **Enable compression**:
```bash
flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true
```

2. **Optimize images**:
- Use WebP format when possible
- Compress images before adding to assets
- Consider lazy loading for large images

3. **Code splitting**:
- Use deferred imports for large features
- Implement route-based code splitting

## 📊 Analytics and Monitoring

### Google Analytics
1. Add your GA tracking ID to `lib/constants/app_constants.dart`
2. Implement tracking in your app
3. Monitor user behavior and performance

### Firebase Analytics
1. Enable Firebase Analytics in your project
2. Add tracking events for user interactions
3. Monitor app performance and crashes

## 🔒 Security Considerations

1. **HTTPS Only**: Firebase Hosting provides HTTPS by default
2. **Content Security Policy**: Configure CSP headers in `firebase.json`
3. **Input Validation**: Validate all user inputs
4. **API Security**: Secure your backend APIs

## 📈 Scaling

### CDN Configuration
Firebase Hosting automatically provides CDN distribution. For custom domains:
1. Add custom domain in Firebase Console
2. Configure DNS records
3. Enable SSL certificate

### Performance Monitoring
1. Use Firebase Performance Monitoring
2. Monitor Core Web Vitals
3. Track user experience metrics

## 🎯 Next Steps

After deployment:
1. Test on multiple devices and browsers
2. Monitor performance metrics
3. Gather user feedback
4. Implement continuous deployment
5. Add monitoring and alerting

## 📞 Support

For issues or questions:
1. Check Flutter web documentation
2. Review Firebase Hosting docs
3. Check Flutter GitHub issues
4. Consult Flutter community forums

---

**Happy Deploying! 🎉**
