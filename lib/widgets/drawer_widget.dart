import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/models.dart';
import '../pages/pages.dart';
import '../utils/utils.dart';
import 'dialogs.dart';
 
class CustomDrawer {
 
  static int selectedDrawerIndex = 1;
 
  static _onTapDrawer(int itemPos, BuildContext context, String language){
    switch(itemPos) {
      case 0:
        EncryptUtil.instance.reset();
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
        break;
      case 1:
        ShowDialogs.showChangeLanguage(context, language);
        break;
      case 2:
      Navigator.pushReplacementNamed(context, CompletedTasksPage.routeName);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, SettingsPage.routeName);
        break;
    }
  }
 
  static Widget getDrawer(BuildContext context) {
    final words = AppLocalizations.of(context)!;
    final drawerItems = [DrawerItem(words.logOut, Icons.logout), DrawerItem(words.language, Icons.language), DrawerItem(words.tasksDoneTitle, Icons.task_outlined), 
      DrawerItem(words.settings, Icons.tune_outlined)];
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      if (i == 1) {
        drawerOptions.add(
          ExpansionTile(
            leading: Icon(d.icon),
            title: Text(d.title),
            children: [
              ListTile(
                title: Text(words.enL),
                selected: i == selectedDrawerIndex,
                onTap: () => _onTapDrawer(i, context, "en"),
              ), 
              ListTile(
                title: Text(words.esL),
                selected: i == selectedDrawerIndex,
                onTap: () => _onTapDrawer(i, context, "es"),
              ), 
            ],
          )
        );
        
      } else {
        drawerOptions.add(ListTile(
          leading: Icon(d.icon),
          title: Text(d.title),
          selected: i == selectedDrawerIndex,
          onTap: () => _onTapDrawer(i, context, ""),
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