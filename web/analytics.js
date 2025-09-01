// Google Analytics configuration for web app
window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('js', new Date());

// Replace with your actual Google Analytics ID
gtag('config', 'G-XXXXXXXXXX');

// Track page views
function trackPageView(page) {
  gtag('config', 'G-XXXXXXXXXX', {
    page_path: page
  });
}

// Track custom events
function trackEvent(action, category, label, value) {
  gtag('event', action, {
    event_category: category,
    event_label: label,
    value: value
  });
}

// Track user interactions
function trackUserInteraction(interactionType, details) {
  gtag('event', 'user_interaction', {
    event_category: 'engagement',
    event_label: interactionType,
    custom_parameters: details
  });
}

// Export functions for use in Flutter
window.trackPageView = trackPageView;
window.trackEvent = trackEvent;
window.trackUserInteraction = trackUserInteraction;
