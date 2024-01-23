
import 'package:flutter/material.dart';

class Buttons {

  static Widget dateButtons(String text, IconData icon, Color color, Function function, bool isButtonEnabled) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.grey.withOpacity(0.1)
      ),
      child: TextButton.icon(
        onPressed: isButtonEnabled ? () => function() : null,
        icon: Icon(icon, color: color,),
        label: Text(text, style: const TextStyle(color: Colors.black),),
      )       
    );
  }
}