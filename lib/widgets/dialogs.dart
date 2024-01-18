import 'package:flutter/material.dart';

import '../pages/pages.dart';

class ShowDialogs {
  static void showNormalDialog(String title, String text, BuildContext context) {
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

  static void showButtonDialog(String title, String text, String buttonName, BuildContext context) {
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
          actions: [
            TextButton(
              child: Text(buttonName),
              onPressed: () => Navigator.pushReplacementNamed(context, RegisterPage.routeName),
            )
          ],
        );
      }
    );
  }
}

