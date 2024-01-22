
import 'package:flutter/material.dart';

class IconDataHelper {
  static IconData getIconData(String iconString) {
    try {
      // Attempt to convert the string to IconData
      return IconData(int.parse(iconString), fontFamily: 'MaterialIcons');
    } catch (e) {
      // Return a default icon if conversion fails
      return Icons.error;
    }
  }
}

class MaterialColorHelper {
  static MaterialColor getMaterialColor(int colorValue) {
    try {
      Color color = Color(colorValue);
      // Create a MaterialColor from the hex color value
      return MaterialColor(
        colorValue,
        <int, Color>{
          50: color.withOpacity(0.1),
          100: color.withOpacity(0.2),
          200: color.withOpacity(0.3),
          300: color.withOpacity(0.4),
          400: color.withOpacity(0.5),
          500: color, // Color principal
          600: color.withOpacity(0.6),
          700: color.withOpacity(0.7),
          800: color.withOpacity(0.8),
          900: color.withOpacity(0.9),
        },
      );
    } catch (e) {
      // Return a default color if conversion fails
      return Colors.grey;
    }
  }
}