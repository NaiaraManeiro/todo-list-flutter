
import 'package:flutter/material.dart';

import '../model/models.dart';
import '../pages/pages.dart';
import '../providers/providers.dart';
import 'widgets.dart';

class CategoryCard {

  static Widget getCategoryCard(BuildContext context, CardItem item, MainPageProvider mainPageProvider, SettingsProvider settingsProvider) {
    return GestureDetector (
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
          child: CategoryWidget.getCategoryWidget(context, item, true, mainPageProvider, settingsProvider),
        )
      ),
      onTap: () {
        Navigator.pushReplacementNamed(context, InfoCategoryPage.routeName, 
            arguments: {
              'item': item
            }
          );
      }
    );
  }
}