#!/bin/bash

# Auto-save script for Flutter Web App
echo "🔄 Auto-saving changes to GitHub..."

# Add all changes
git add .

# Check if there are changes to commit
if git diff --cached --quiet; then
    echo "✅ No changes to commit"
else
    # Commit with timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    git commit -m "Auto-save: $timestamp - Flutter app updates"
    
    # Push to GitHub
    echo "📤 Pushing to GitHub..."
    git push origin main
    
    if [ $? -eq 0 ]; then
        echo "✅ Changes successfully saved to GitHub!"
    else
        echo "❌ Error pushing to GitHub"
    fi
fi

echo "✨ Auto-save complete!"
