import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  static void showButtonDialog(String title, String text, String buttonName, BuildContext context, Function onPressedCallback) {
    AppLocalizations words = AppLocalizations.of(context)!;
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
              onPressed: () => onPressedCallback(),
            ),
            TextButton(
              child: Text(words.dialogButtonCancel),
              onPressed: () => Navigator.of(context).pop()
            )
          ],
        );
      }
    );
  }

  static void showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

