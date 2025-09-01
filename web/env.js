// Environment configuration for web app
window.env = {
  // App configuration
  APP_NAME: 'China Prices',
  APP_VERSION: '1.0.0',
  
  // API endpoints
  API_BASE_URL: 'https://your-api-domain.com',
  
  // Firebase configuration
  FIREBASE_API_KEY: 'your-api-key',
  FIREBASE_AUTH_DOMAIN: 'your-project.firebaseapp.com',
  FIREBASE_PROJECT_ID: 'your-project-id',
  FIREBASE_STORAGE_BUCKET: 'your-project.appspot.com',
  FIREBASE_MESSAGING_SENDER_ID: 'your-sender-id',
  FIREBASE_APP_ID: 'your-app-id',
  
  // Analytics
  GOOGLE_ANALYTICS_ID: 'G-XXXXXXXXXX',
  
  // Feature flags
  ENABLE_PWA: true,
  ENABLE_OFFLINE: true,
  ENABLE_NOTIFICATIONS: true,
  ENABLE_ANALYTICS: true,
  
  // Performance settings
  CACHE_DURATION: 24 * 60 * 60 * 1000, // 24 hours in milliseconds
  MAX_CACHE_SIZE: 50 * 1024 * 1024, // 50MB
  
  // Debug mode
  DEBUG: false
};

// Environment-specific overrides
if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
  window.env.DEBUG = true;
  window.env.API_BASE_URL = 'http://localhost:3000';
}
