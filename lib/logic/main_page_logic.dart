
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../helpers/helpers.dart';
import '../model/models.dart';
import '../pages/pages.dart';
import '../providers/providers.dart';
import '../../assets/constants.dart' as constants;
import '../widgets/widgets.dart';

class MainPageLogic {

  final MainPageProvider _provider;

  MainPageLogic(this._provider);

  Future<List<CardItem>?> getUserCategories(BuildContext context) async {
    final email = await SharedPrefHelper.getString(constants.email);
    return await SQLHelper.getUserCategories(context, email);
  }

  List<Widget>? getCards(context, settingsProvider) {
    if (_provider.userCategories == null) {
      return null;
    } else {
      return List.generate(_provider.userCategories!.length, (index) {
        return CategoryCard.getCategoryCard(context, _provider.userCategories!.elementAt(index), _provider, settingsProvider);
      });
    }
  }

  Future<List<CardItem>?> getCategories() async {
    final email = await SharedPrefHelper.getString(constants.email);
    return await SQLHelper.getCategories(email);
  }

  Future<String> getUserName() async{
    final email = await SharedPrefHelper.getString(constants.email);
    return await SQLHelper.getUserName(email);
  }

  void deleteCategory(String nameCategory, SettingsProvider settingsProvider) async {
    AppLocalizations words = AppLocalizations.of(_provider.context)!;
    if (settingsProvider.currentMinValue == _provider.categoryMinValue) {
      ShowDialogs.showButtonDialog(words.dialogAlertTitle, words.minCategoryText, words.settings, _provider.context, 
        () => Navigator.pushReplacementNamed(_provider.context, SettingsPage.routeName)
      );
    } else {
      final email = await SharedPrefHelper.getString(constants.email);

      ShowDialogs.showButtonDialog(words.dialogAlertTitle, words.dialogDeleteCategoryText, words.deleteCategory, _provider.context, 
        () async {
          await SQLHelper.deleteUserCategory(email, nameCategory, "category");
          Navigator.of(_provider.context).pop();
          _provider.userCategories!.removeWhere((element) => element.nameCategory == nameCategory);
          _provider.categories!.removeWhere((element) => element.nameCategory == nameCategory);
          _provider.refresh();
        }
      );
    }
  }

  void deleteAllTasksCategory(String nameCategory) async {
    AppLocalizations words = AppLocalizations.of(_provider.context)!;
    final email = await SharedPrefHelper.getString(constants.email);

    ShowDialogs.showButtonDialog(words.dialogAlertTitle, words.dialogDeleteCategoryText, words.deleteCategory, _provider.context, 
      () async {
        await SQLHelper.deleteUserCategory(email, nameCategory, "tasks");
        Navigator.of(_provider.context).pop();
        _provider.userCategories!.removeWhere((element) => element.nameCategory == nameCategory);
        _provider.refresh();
      });
  }

  void editCategories(CardItem item) async {
    final email = await SharedPrefHelper.getString(constants.email);
    List<TaskModel> tasks = await SQLHelper.getTasksCategory(email, item.nameCategory);
    Navigator.pushReplacementNamed(_provider.context, NewTaskPage.routeName, 
      arguments: {
        'item' : item,
        'tasks': tasks
      }
    );
  }

  Future<int> getCategoryMaxValue() async {
    final email = await SharedPrefHelper.getString(constants.email);
    return int.parse(await SQLHelper.getSettingValue(email, constants.categoryMax));
  }

  Future<int> getCategoryMinValue() async {
    final email = await SharedPrefHelper.getString(constants.email);
    return int.parse(await SQLHelper.getSettingValue(email, constants.categoryMin));
  }
}