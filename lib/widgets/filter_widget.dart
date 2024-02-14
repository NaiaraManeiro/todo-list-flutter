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
        _pickDate(context, completedTasksProvider!, "start");
        break;
      case 2:
        _pickDate(context, completedTasksProvider!, "end");
        break;
      case 3:
        _limpiarFiltro(completedTasksProvider!);
        break;
    }
  }

  static Widget getDrawerFilter(BuildContext context, CompletedTasksProvider completedTasksProvider) {
    final words = AppLocalizations.of(context)!;
    final drawerItems = [DrawerItem(words.categoriesFilter, Icons.category_outlined), DrawerItem(words.startDateFilter, Icons.today_outlined), 
      DrawerItem(words.endDateFilter, Icons.event_outlined), DrawerItem(words.clearFilter, Icons.clear_outlined)];
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      if (i == 3) {
        drawerOptions.add(
          Column(
            children: [
              const Divider(),
              ListTile(
                leading: Icon(d.icon),
                title: Text(d.title),
                selected: i == selectedDrawerIndex,
                onTap: () => _onTapFilter(i, context, completedTasksProvider),
              )
            ]
          )
        );
      } else {
        drawerOptions.add(
          ListTile(
            leading: Icon(d.icon),
            title: Text(d.title),
            onTap: () => _onTapFilter(i, context, completedTasksProvider),
          )
        );
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

  static void _pickDate(BuildContext context, CompletedTasksProvider completedTasksProvider, String date) async {
    DateTime? fecha = date == "start" ? completedTasksProvider.startDate : completedTasksProvider.endDate;
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fecha ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != fecha) {
      if (date == "start") {
        completedTasksProvider.startDate = pickedDate;
      } else {
        completedTasksProvider.endDate = pickedDate;
      }
      completedTasksProvider.refresh();
    }
  }

  static void _limpiarFiltro(CompletedTasksProvider completedTasksProvider) {
    completedTasksProvider.selectedCategories = List.filled(completedTasksProvider.copyList!.length, true);
    completedTasksProvider.startDate = null;
    completedTasksProvider.endDate = null;
    completedTasksProvider.refresh();
  }
}