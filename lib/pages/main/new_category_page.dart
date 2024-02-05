import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../model/models.dart';
import '../../providers/providers.dart';
import '../../ui/uis.dart';
import '../pages.dart';


class NewCategoryPage extends StatefulWidget {
  static String routeName = "newCategory";

  const NewCategoryPage({super.key});

  @override
  State<NewCategoryPage> createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  bool data = true;

  void changeColor(Color color, CategoryProvider categoryProvider) {
    setState(() => categoryProvider.currentColor = color);
  }

  _pickIcon(CategoryProvider categoryProvider) async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.material]);

    setState(() {
      categoryProvider.selectedIcon = icon ?? Icons.highlight_off_outlined;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations words = AppLocalizations.of(context)!;
    final categoryProvider = Provider.of<CategoryProvider>(context)..setContext(context);

    // Extracting arguments
    final Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final CardItem? item = arguments?['item'];
    List<TaskModel> tasks = arguments?['tasks'].cast<TaskModel>().toList();

    if (data) {
      if (item != null) {
        categoryProvider.logic.setData(item);
      } else {
        categoryProvider.logic.cleanData();
      }
      data = false;
    }
    
    
    return Scaffold(
      appBar: AppBar(
        title: Text(item != null ? words.editCategory : words.newCategory),
        leading: IconButton(
                icon: Icon(Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios, color: Colors.black,),
                onPressed: () => item != null 
                    ? Navigator.pushReplacementNamed(context, NewTaskPage.routeName, 
                        arguments: {
                          'item': item,
                          'tasks': tasks
                        }
                      )
                    : Navigator.pushReplacementNamed(context, MainPage.routeName),
              ),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.check), onPressed: () => item != null
            ? categoryProvider.logic.updateCategory(words, item, tasks)
            : categoryProvider.logic.newCategory(words)
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            Form(
              key: categoryProvider.newCategoryKey,
              child: TextFormField(
                controller: categoryProvider.newCategoryController,
                autocorrect: false,
                decoration: InputDecorations.authInputDecoration(labelText: words.newCatName, prefixIcon: Icons.category_outlined),
                onChanged: (value) {
                  categoryProvider.newCategoryKey.currentState?.validate();
                  categoryProvider.newCategory = value;
                  
                }, 
                validator: (value) => categoryProvider.logic.validateCategory(words, value),
                maxLength: 20,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                ],
              ),
            ),
            const SizedBox(height: 25,),
            Text(words.colorCategory, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  color: categoryProvider.currentColor,
                ),
                const SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(words.pickColor),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: categoryProvider.currentColor,
                              onColorChanged: (Color color) => changeColor(color, categoryProvider),
                              pickerAreaHeightPercent: 0.8,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(words.dialogButtonAccept),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(words.pickColor),
                ),
              ],
            ),
            const SizedBox(height: 35),
            Text(words.iconCategory, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  child: Icon(
                    categoryProvider.selectedIcon,
                    size: 50.0,
                    color: categoryProvider.currentColor,
                  )
                ),
                const SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () => _pickIcon(categoryProvider),
                  child: Text(words.pickIcon),
                ),
              ]
            )
          ],
        ),
      )
    );
  }
}