import 'package:flutter/material.dart';

class ShowDialogs {
  static void showRegisterDialog(String title, String text, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              const SizedBox(height: 10,),
              Text(text),
            ],
          ),
        );
      }
    );
  }
}

