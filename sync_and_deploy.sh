#!/bin/bash

# ========================================
# AUTO SYNC & DEPLOY SCRIPT
# ========================================
# This script automatically:
# 1. Saves changes to GitHub
# 2. Builds the Flutter web app
# 3. Deploys to Firebase Hosting
# 4. Shows the live URL
# ========================================

echo "🚀 Starting Auto Sync & Deploy Process..."
echo "=========================================="

# Step 1: Save to GitHub
echo "📤 Step 1: Saving changes to GitHub..."
git add .
git commit -m "Auto-sync: $(date '+%Y-%m-%d %H:%M:%S') - Flutter app updates"
git push origin main

if [ $? -eq 0 ]; then
    echo "✅ Changes successfully saved to GitHub!"
else
    echo "❌ Error saving to GitHub"
    exit 1
fi

echo ""

# Step 2: Build Flutter Web App
echo "🔨 Step 2: Building Flutter Web App..."
flutter build web --no-tree-shake-icons

if [ $? -eq 0 ]; then
    echo "✅ Flutter web app built successfully!"
else
    echo "❌ Error building Flutter web app"
    exit 1
fi

echo ""

# Step 3: Deploy to Firebase Hosting
echo "🌐 Step 3: Deploying to Firebase Hosting..."
firebase deploy --only hosting

if [ $? -eq 0 ]; then
    echo "✅ Successfully deployed to Firebase Hosting!"
else
    echo "❌ Error deploying to Firebase"
    exit 1
fi

echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo "=========================================="
echo "🌐 Your live app: https://prices-in-china-5204c.web.app"
echo "📱 Firebase Console: https://console.firebase.google.com/project/prices-in-china-5204c"
echo "📊 Google Analytics: https://analytics.google.com"
echo ""
echo "⏰ Deployment time: $(date '+%Y-%m-%d %H:%M:%S')"
echo "✨ Changes are now live on your website!"
echo ""
echo "💡 Tip: Refresh your browser to see the changes immediately!"
