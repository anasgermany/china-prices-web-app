# Category Editing Guide

## Overview
The categories in the home screen are now fully editable from the constants file. You can change the name, icon, image, and JSON URL for each category without affecting the app's functionality.

## How to Edit Categories

### Location
Edit the categories in: `lib/constants/app_constants.dart`

### What You Can Change

1. **Name**: Change the display name of the category
2. **Icon**: Set to null to show only image, or use Material Icons code points
3. **Image URL**: Set to null to show only icon, or provide an image URL
4. **JSON URL**: Point to your category's product JSON file
5. **Color**: Add custom colors (optional)

## Examples

### Example 1: Change Electronics to Wigs
```dart
{
  'name': 'Wigs', // Changed from 'Electronics'
  'icon': 0xe3e4, // Keep the same icon
  'imageUrl': 'https://your-wigs-image-url.com/image.jpg', // Change image
  'jsonUrl': 'https://your-wigs-json-url.com/wigs.json', // Change JSON URL
},
```

### Example 2: Show Only Image (No Icon)
```dart
{
  'name': 'Fashion',
  'icon': null, // No icon, only image
  'imageUrl': 'https://your-fashion-image-url.com/image.jpg',
  'jsonUrl': 'https://your-fashion-json-url.com/fashion.json',
},
```

### Example 3: Show Only Icon (No Image)
```dart
{
  'name': 'Home & Garden',
  'icon': 0xe3e6, // Icons.home
  'imageUrl': null, // No image, only icon
  'jsonUrl': 'https://your-home-json-url.com/home.json',
},
```

### Example 4: Add Custom Color
```dart
{
  'name': 'Sports',
  'icon': 0xe3e7, // Icons.sports_soccer
  'imageUrl': 'https://your-sports-image-url.com/image.jpg',
  'jsonUrl': 'https://your-sports-json-url.com/sports.json',
  'color': 0xFF4CAF50, // Custom green color
},
```

## Icon Codes

Use Material Icons code points. Find icons at: https://fonts.google.com/icons

Common icon codes:
- `0xe3e4` - Icons.devices (Electronics)
- `0xe3e5` - Icons.checkroom (Fashion)
- `0xe3e6` - Icons.home (Home)
- `0xe3e7` - Icons.sports_soccer (Sports)
- `0xe3e8` - Icons.toys (Toys)
- `0xe3e9` - Icons.face (Beauty)
- `0xe3ea` - Icons.directions_car (Automotive)
- `0xe3eb` - Icons.health_and_safety (Health)
- `0xe3ec` - Icons.book (Books)

## Color Codes

Use hexadecimal color codes:
- `0xFFE91E63` - Pink
- `0xFF4CAF50` - Green
- `0xFF2196F3` - Blue
- `0xFFFF9800` - Orange
- `0xFF9C27B0` - Purple
- `0xFFF44336` - Red

## Important Notes

1. **Safe to Leave Empty**: If you set `icon` or `imageUrl` to `null`, the app will still work perfectly
2. **JSON URLs**: Make sure your JSON URLs are valid and accessible
3. **Image URLs**: Use high-quality images for best results
4. **Names**: You can use any name you want, including special characters
5. **No App Restart**: Changes take effect immediately when you save the file

## Troubleshooting

- If a category doesn't show: Check that the JSON URL is valid
- If images don't load: Verify the image URL is accessible
- If icons don't show: Make sure the icon code is correct
- If colors don't apply: Ensure the color code is in the correct format (0xFF...)

## Complete Example

Here's how you could change all categories to custom ones:

```dart
static const List<Map<String, dynamic>> editableCategories = [
  {
    'name': 'Wigs',
    'icon': null,
    'imageUrl': 'https://your-wigs-image.com/wigs.jpg',
    'jsonUrl': 'https://your-wigs-json.com/wigs.json',
  },
  {
    'name': 'Cars',
    'icon': 0xe3ea, // Icons.directions_car
    'imageUrl': null,
    'jsonUrl': 'https://your-cars-json.com/cars.json',
    'color': 0xFF2196F3, // Blue
  },
  {
    'name': 'Phones',
    'icon': 0xe3e4, // Icons.devices
    'imageUrl': 'https://your-phones-image.com/phones.jpg',
    'jsonUrl': 'https://your-phones-json.com/phones.json',
  },
  // Add more categories as needed...
];
```
