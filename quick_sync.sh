#!/bin/bash

# ========================================
# QUICK SYNC & DEPLOY SCRIPT
# ========================================
# Fast deployment for immediate changes
# ========================================

echo "⚡ Quick Sync & Deploy Starting..."
echo "=================================="

# Quick GitHub sync
echo "📤 Quick GitHub sync..."
git add .
git commit -m "Quick sync: $(date '+%H:%M:%S')"
git push origin main

# Quick build
echo "🔨 Quick build..."
flutter build web --no-tree-shake-icons

# Quick deploy
echo "🌐 Quick deploy..."
firebase deploy --only hosting

echo ""
echo "✅ Quick sync complete!"
echo "🌐 Live at: https://prices-in-china-5204c.web.app"
