import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../ui/uis.dart';
import '../pages.dart';
import '../../assets/constants.dart' as constants;

class SettingsPage extends StatefulWidget {
  static String routeName = "settings";

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int? _currentMaxValue;
  int? _currentMinValue;

  @override
  Widget build(BuildContext context) {
    AppLocalizations words = AppLocalizations.of(context)!;
    final settingsProvider = Provider.of<SettingsProvider>(context)..setContext(context);

    _currentMaxValue ??= settingsProvider.currentMaxValue;
    _currentMinValue ??= settingsProvider.currentMinValue;

    return Scaffold(
      appBar: AppBar(
        title: Text(words.settings),
        leading: IconButton(
                icon: Icon(Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios, color: Colors.black,),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, MainPage.routeName);
                } 
              ),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.check), onPressed: () {
            settingsProvider.currentMaxValue = _currentMaxValue;
            settingsProvider.currentMinValue = _currentMinValue;
            settingsProvider.logic.saveSettings(words);
          })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Center(
                    child: Text(words.settingsCategory, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(words.catMax),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: NumberPicker(
                          value: _currentMaxValue ?? int.parse(constants.categoryMaxValue),
                          axis: Axis.horizontal,
                          minValue: int.parse(constants.categoryMinValue),
                          maxValue: int.parse(constants.categoryMaxValue),
                          onChanged: (value) => setState(() => _currentMaxValue = value),
                          decoration: WidgetDecorations.numberPickerDecoration(),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(words.catMin),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: NumberPicker(
                          value: _currentMinValue ?? int.parse(constants.categoryMinValue),
                          axis: Axis.horizontal,
                          minValue: int.parse(constants.categoryMinValue),
                          maxValue: int.parse(constants.categoryMaxValue),
                          onChanged: (value) => setState(() => _currentMinValue = value),
                          decoration: WidgetDecorations.numberPickerDecoration(),
                        ),
                      )
                    ],
                  )
                ]
              )
            ),
            const SizedBox(height: 5,),
            const Divider()
          ]
        )
      )   
    );
  }
}