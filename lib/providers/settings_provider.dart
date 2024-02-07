import 'package:flutter/material.dart';

import '../logic/logics.dart';
import '../../assets/constants.dart' as constants;

class SettingsProvider extends ChangeNotifier {
  late SettingsLogic logic;
  late BuildContext context;

  int? currentMaxValue;
  int? currentMinValue;

  SettingsProvider(){
    logic = SettingsLogic(this);
  }

  void setContext(BuildContext context) async {
    this.context = context;

    List<Map<String, dynamic>> settings = await logic.getSettings();

    for (Map<String, dynamic> setting in settings) {
      if (setting['setting'] == constants.categoryMax) {
        currentMaxValue = int.parse(setting['value']);
      } else if (setting['setting'] == constants.categoryMin) {
        currentMinValue = int.parse(setting['value']);
      }
    }

    refresh();
  }

  void refresh() {
    notifyListeners();
  }

}