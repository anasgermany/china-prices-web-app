# Category JSON Setup Guide

## Overview
Each category in the app now uses its own GitHub JSON file, allowing you to easily update products for specific categories without affecting others.

## Current Category JSON Links

The following categories are configured with their own JSON files:

| Category | JSON File | GitHub Link |
|----------|-----------|-------------|
| Electronics | `electronics.json` | `https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/electronics.json` |
| Fashion | `fashion.json` | `https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/fashion.json` |
| Home & Garden | `home_garden.json` | `https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/home_garden.json` |
| Sports | `sports.json` | `https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/sports.json` |
| Toys & Games | `RCtoyyyyyyyyyyyyyyyyy.json` | `https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/RCtoyyyyyyyyyyyyyyyyy.json` |
| Beauty | `beauty.json` | `https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/beauty.json` |
| Automotive | `automotive.json` | `https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/automotive.json` |
| Health | `health.json` | `https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/health.json` |
| Books | `books.json` | `https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/books.json` |

## How to Update Category Products

### Method 1: Update Existing JSON Files
1. Go to your GitHub repository: `https://github.com/anasgermany/Anas`
2. Navigate to the specific JSON file for the category you want to update
3. Edit the file and add/remove products
4. Commit and push the changes
5. The app will automatically use the updated products

### Method 2: Create New JSON Files
1. Create a new JSON file with the same structure as the existing ones
2. Upload it to your GitHub repository
3. Update the link in `lib/constants/app_constants.dart`:

```dart
static const Map<String, String> categoryJsonLinks = {
  'Your Category': 'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/your_new_file.json',
  // ... other categories
};
```

## JSON File Structure

Each JSON file should contain an array of products with the following structure:

```json
[
  {
    "ProductId": 1005004572453697,
    "Image Url": "https://ae04.alicdn.com/kf/S87fb4422f4664de6aa23e486c1efcddf7.jpg",
    "Video Url": "",
    "Product Desc": "Product Description",
    "Origin Price": "USD 4.75",
    "Discount Price": "USD 4.27",
    "Discount": "10%",
    "Currency": "USD",
    "Commission Rate": 7,
    "Commission": "USD 0.30",
    "Sales180Day": 26,
    "Positive Feedback": "100.0%",
    "Promotion Url": "https://s.click.aliexpress.com/e/_DEnQJ03"
  }
]
```

## Benefits

1. **Independent Updates**: Update products for one category without affecting others
2. **Easy Management**: Each category has its own file for better organization
3. **Real-time Updates**: Changes are reflected immediately in the app
4. **Scalability**: Easy to add new categories or modify existing ones

## Troubleshooting

- If a category shows no products, check that the JSON file exists and is accessible
- Ensure the JSON file has the correct structure
- Verify that the GitHub link is correct and the file is in the right branch
- Check that the JSON file contains valid product data

## Adding New Categories

To add a new category:

1. Create the JSON file with product data
2. Upload it to your GitHub repository
3. Add the category to `categoryJsonLinks` in `app_constants.dart`
4. Add the category to `categoryImages` for the category image
5. Update the categories list in `home_screen.dart`
