#!/bin/bash

# Watch and auto-save script for Flutter Web App
echo "👀 Watching for changes and auto-saving..."

# Function to save changes
save_changes() {
    echo "🔄 Changes detected! Auto-saving..."
    git add .
    
    if git diff --cached --quiet; then
        echo "✅ No changes to commit"
    else
        timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        git commit -m "Auto-save: $timestamp - Flutter app updates"
        
        echo "📤 Pushing to GitHub..."
        git push origin main
        
        if [ $? -eq 0 ]; then
            echo "✅ Changes successfully saved to GitHub!"
        else
            echo "❌ Error pushing to GitHub"
        fi
    fi
    echo "✨ Auto-save complete!"
}

# Check if fswatch is available (macOS)
if command -v fswatch &> /dev/null; then
    echo "📱 Using fswatch (macOS)..."
    fswatch -o . | while read f; do
        save_changes
    done
# Check if inotifywait is available (Linux)
elif command -v inotifywait &> /dev/null; then
    echo "🐧 Using inotifywait (Linux)..."
    while inotifywait -r -e modify,create,delete .; do
        save_changes
    done
else
    echo "⚠️  No file watcher available. Please install fswatch (macOS) or inotifywait (Linux)"
    echo "💡 For now, you can use: ./auto_save.sh to manually save changes"
fi
