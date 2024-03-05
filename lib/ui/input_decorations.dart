import 'package:flutter/material.dart';

class WidgetDecorations {
  static InputDecoration authInputDecoration({required String labelText, IconData? prefixIcon, Widget? suffixIcon}) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black
        )
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
          width: 2
        )
      ),
      labelText: labelText,
      labelStyle: const TextStyle(
        color: Colors.grey
      ),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.black,) : null,
      errorMaxLines: 3,
      suffixIcon: suffixIcon 
    );
  }

  static BoxDecoration numberPickerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.black26),
    );
  }
}