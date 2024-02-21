import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../helpers/helpers.dart';
import '../assets/constants.dart' as constants;
import '../providers/providers.dart';

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

  static showChangeLanguage(BuildContext context, String language) {
    final words = AppLocalizations.of(context)!;
    Locale newLocale = const Locale('es', 'ES');
    SharedPrefHelper.getString(constants.languageCode).then((value) => {
      if (value != language) {
        showDialog(context: context, builder: (BuildContext contextDialog) {
          return AlertDialog(
            title: Text(words.dialogChangeLangTitle),        
            content: Wrap(
              children: [ Column(
                children: [
                  const SizedBox(height: 5,),
                  Text(language == 'es'
                    ? words.dialogChangeLangText(words.esL)
                    : words.dialogChangeLangText(words.enL)
                  ),
                ],
              ),]
            ),
            actions: [
              TextButton(                     
                onPressed: () => {
                  if(language == "en") {
                    newLocale = const Locale('en', 'EN')
                  }, 
                  Get.updateLocale(newLocale),
                  SharedPrefHelper.setString(constants.languageCode, newLocale.languageCode),
                  Navigator.of(contextDialog).pop()
                },     
                child: Text(words.dialogChangeLangButtonOk),
              ),
              TextButton(                     
                onPressed: () => Navigator.of(contextDialog).pop(),     
                child: Text(words.dialogButtonCancel),
              ),
            ],
          );
        })           
      }  
    });
  }

  static void showCategoryDialog(BuildContext context, CompletedTasksProvider completedTasksProvider) {
    AppLocalizations words = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(words.selectCategories),
          content: SingleChildScrollView(
            child: Column(
              children: List.generate(completedTasksProvider.copyList!.length, (index) {
                final category = completedTasksProvider.copyList![index];
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return CheckboxListTile(
                      title: Text(category.nameCategory),
                      value: completedTasksProvider.selectedCategories![index],
                      onChanged: (bool? value) {
                        setState(() {
                          completedTasksProvider.selectedCategories![index] = value ?? false;
                        });
                      },
                    );
                  }
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(words.dialogButtonCancel),
            ),
          ],
        );
      },
    );
  }
}

