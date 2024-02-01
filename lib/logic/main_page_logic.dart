
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

  List<Widget>? getCards(context) {
    if (_provider.userCategories == null) {
      return null;
    } else {
      return List.generate(_provider.userCategories!.length, (index) {
        return CategoryCard.getCategoryCard(context, _provider.userCategories!.elementAt(index));
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

  void deleteCategories(String nameCategory) async {
    AppLocalizations words = AppLocalizations.of(_provider.context)!;
    final email = await SharedPrefHelper.getString(constants.email);

    ShowDialogs.showButtonDialog(words.dialogAlertTitle, words.dialogDeleteCategoryText, words.deleteCategory, _provider.context, 
      () async {
        await SQLHelper.deleteUserCategory(email, nameCategory).then((_) {
          Navigator.of(_provider.context).pop();
          _provider.userCategories!.removeWhere((element) => element.nameCategory == nameCategory);
          _provider.refresh();
        });
      });
  }

  void editCategories(CardItem item) async {
    final email = await SharedPrefHelper.getString(constants.email);
    SQLHelper.getTasksCategory(email, item.nameCategory).then((tasks) => 
      Navigator.pushReplacementNamed(_provider.context, NewTaskPage.routeName, 
        arguments: {
          'item' : item,
          'tasks': tasks
        }
      )
    );
  }
}