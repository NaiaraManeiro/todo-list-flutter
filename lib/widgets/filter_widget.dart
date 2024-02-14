
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/models.dart';
import '../providers/providers.dart';
import 'widgets.dart';

class CustomFilter {
 
  static int selectedDrawerIndex = 1;
 
  static _onTapFilter(int itemPos, BuildContext context, CompletedTasksProvider? completedTasksProvider){
    switch(itemPos) {
      case 0:
        ShowDialogs.showCategoryDialog(context, completedTasksProvider!);
        break;
      case 1:
        break;
      case 2:
        break;
      
    }
  }

  static Widget getDrawerFilter(BuildContext context, CompletedTasksProvider completedTasksProvider) {
    final words = AppLocalizations.of(context)!;
    final drawerItems = [DrawerItem(words.categoriesFilter, Icons.category_outlined), DrawerItem(words.startDateFilter, Icons.today_outlined), DrawerItem(words.endDateFilter, Icons.event_outlined)];
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      if (i == 0) {
        drawerOptions.add(ListTile(
          leading: Icon(d.icon),
          title: Text(d.title),
          selected: i == selectedDrawerIndex,
          onTap: () => _onTapFilter(i, context, completedTasksProvider),
        ));
      } else {
        drawerOptions.add(ListTile(
          leading: Icon(d.icon),
          title: Text(d.title),
          selected: i == selectedDrawerIndex,
          onTap: () => _onTapFilter(i, context, null),
        ));
      }
    }
 
    return Drawer(
      width: 200,
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          const FlutterLogo(size: 150),
          const Divider(),
          Column(children: drawerOptions)
        ],
      ),
    );
  }
}