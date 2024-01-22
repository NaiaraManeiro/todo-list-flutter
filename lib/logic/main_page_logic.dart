
import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import '../providers/providers.dart';
import '../../assets/constants.dart' as constants;
import '../widgets/widgets.dart';

class MainPageLogic {

  final MainPageProvider _provider;

  MainPageLogic(this._provider);

  Future<List<CardItem>?> getCategories(BuildContext context) async {
    final email = await SharedPrefHelper.getString(constants.email);
    return await SQLHelper.getUserCategories(context, email);
  }

  List<Widget>? getCards(context) {
    if (_provider.categories == null) {
      return null;
    } else {
      return List.generate(_provider.categories!.length, (index) {
        return CategoryCard.getCategoryCard(context, _provider.categories!.elementAt(index));
      });
    }
  }
}