#!/bin/bash

# ========================================
# AUTO WATCH & DEPLOY SCRIPT
# ========================================
# This script watches for file changes and automatically:
# 1. Detects when you save files
# 2. Saves to GitHub
# 3. Builds and deploys to Firebase
# 4. Shows live status
# ========================================

echo "👀 Starting Auto Watch & Deploy Mode..."
echo "======================================="
echo "📱 Watching for changes in your Flutter app..."
echo "🔄 Any file change will trigger automatic deployment"
echo "⏹️  Press Ctrl+C to stop watching"
echo ""

# Function to deploy
deploy_changes() {
    echo ""
    echo "🔄 Changes detected! Starting deployment..."
    echo "=========================================="
    
    # Save to GitHub
    echo "📤 Saving to GitHub..."
    git add .
    git commit -m "Auto-deploy: $(date '+%Y-%m-%d %H:%M:%S') - Changes detected"
    git push origin main
    
    if [ $? -eq 0 ]; then
        echo "✅ GitHub sync complete!"
    else
        echo "❌ GitHub sync failed"
        return 1
    fi
    
    # Build Flutter app
    echo "🔨 Building Flutter web app..."
    flutter build web --no-tree-shake-icons
    
    if [ $? -eq 0 ]; then
        echo "✅ Build complete!"
    else
        echo "❌ Build failed"
        return 1
    fi
    
    # Deploy to Firebase
    echo "🌐 Deploying to Firebase..."
    firebase deploy --only hosting
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "🎉 DEPLOYMENT SUCCESSFUL!"
        echo "=========================================="
        echo "🌐 Live URL: https://prices-in-china-5204c.web.app"
        echo "⏰ Deployed at: $(date '+%H:%M:%S')"
        echo "✨ Your changes are now live!"
        echo ""
    else
        echo "❌ Firebase deployment failed"
        return 1
    fi
}

# Check if fswatch is available (macOS)
if command -v fswatch &> /dev/null; then
    echo "📱 Using fswatch (macOS) for file watching..."
    echo "👀 Watching for changes in lib/ directory..."
    echo ""
    
    # Watch for changes in lib directory
    fswatch -o lib/ | while read f; do
        echo "📝 File change detected at $(date '+%H:%M:%S')"
        deploy_changes
        echo ""
        echo "👀 Watching for more changes..."
    done

# Check if inotifywait is available (Linux)
elif command -v inotifywait &> /dev/null; then
    echo "🐧 Using inotifywait (Linux) for file watching..."
    echo "👀 Watching for changes in lib/ directory..."
    echo ""
    
    # Watch for changes in lib directory
    while inotifywait -r -e modify,create,delete lib/; do
        echo "📝 File change detected at $(date '+%H:%M:%S')"
        deploy_changes
        echo ""
        echo "👀 Watching for more changes..."
    done

else
    echo "⚠️  No file watcher available on your system"
    echo "💡 Please install:"
    echo "   - macOS: brew install fswatch"
    echo "   - Linux: sudo apt-get install inotify-tools"
    echo ""
    echo "🔄 For now, you can use: ./sync_and_deploy.sh"
    exit 1
fi
