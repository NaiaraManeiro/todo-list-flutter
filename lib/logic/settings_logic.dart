
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../helpers/helpers.dart';
import '../pages/pages.dart';
import '../providers/providers.dart';
import '../../assets/constants.dart' as constants;
import '../widgets/widgets.dart';

class SettingsLogic {

  final SettingsProvider _provider;

  SettingsLogic(this._provider);

  Future<void> saveSettings(AppLocalizations words) async {
    final email = await SharedPrefHelper.getString(constants.email);

    List<Map<String, dynamic>> settings = [
      {'setting': constants.categoryMax, 'value': _provider.currentMaxValue},
      {'setting': constants.categoryMin, 'value': _provider.currentMinValue},
    ];
    await SQLHelper.saveSettings(email, settings);

    ShowDialogs.showSnackbar(_provider.context, words.settingsSaved);
    Navigator.pushReplacementNamed(_provider.context, MainPage.routeName);
  }

  Future<List<Map<String, dynamic>>> getSettings() async {
    final email = await SharedPrefHelper.getString(constants.email);
    return SQLHelper.getSettings(email);
  }
}