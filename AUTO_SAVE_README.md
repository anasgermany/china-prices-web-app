# Auto-Save Scripts for Flutter Web App

## 🚀 Quick Auto-Save

### Option 1: Manual Auto-Save
```bash
./auto_save.sh
```
This will automatically:
- Add all changes
- Commit with timestamp
- Push to GitHub

### Option 2: Continuous Auto-Save (Recommended)
```bash
./watch_and_save.sh
```
This will:
- Watch for file changes continuously
- Automatically save when changes are detected
- Keep running until you stop it (Ctrl+C)

## 📱 For macOS Users
The watch script uses `fswatch` which is usually pre-installed on macOS.

## 🐧 For Linux Users
You may need to install `inotifywait`:
```bash
sudo apt-get install inotify-tools  # Ubuntu/Debian
```

## 💡 Usage Tips

1. **Start continuous auto-save** when you begin working:
   ```bash
   ./watch_and_save.sh
   ```

2. **Manual save** anytime:
   ```bash
   ./auto_save.sh
   ```

3. **Stop continuous watching**: Press `Ctrl+C`

## 🔧 What Gets Saved
- All modified files
- New files
- Deleted files
- Commits with timestamps
- Automatic push to GitHub main branch

## ⚠️ Important Notes
- Make sure you're on the main branch
- Ensure you have write access to the GitHub repository
- The scripts will only commit if there are actual changes
- All changes are automatically pushed to GitHub

## 🎯 Perfect for Development
These scripts ensure you never lose your work and always have the latest version on GitHub!
