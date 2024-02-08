import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../helpers/helpers.dart';
import '../assets/constants.dart' as constants;
import '../pages/pages.dart';
import '../utils/utils.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}
 
class CustomDrawer {
 
  static int selectedDrawerIndex = 1;
 
  static _onTapDrawer(int itemPos, BuildContext context, String language){
    switch(itemPos) {
      case 0:
        EncryptUtil.instance.reset();
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
        break;
      case 1:
        _showChangeLanguage(context, language);
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

  static _showChangeLanguage(BuildContext context, String language) {
    final words = AppLocalizations.of(context)!;
    Locale newLocale = const Locale('es', 'ES');
    SharedPrefHelper.getString(constants.languageCode).then((value) => {
      if (value != language) {
        showDialog(context: context, builder: (BuildContext contextDialog) {
          return AlertDialog(
            title: Text(words.dialogChangeLangTitle),        
            content: Wrap(
              children: [ Column(
                children: [
                  const SizedBox(height: 5,),
                  Text(language == 'es'
                    ? words.dialogChangeLangText(words.esL)
                    : words.dialogChangeLangText(words.enL)
                  ),
                ],
              ),]
            ),
            actions: [
              TextButton(                     
                onPressed: () => {
                  if(language == "en") {
                    newLocale = const Locale('en', 'EN')
                  }, 
                  Get.updateLocale(newLocale),
                  SharedPrefHelper.setString(constants.languageCode, newLocale.languageCode),
                  Navigator.of(contextDialog).pop()
                },     
                child: Text(words.dialogChangeLangButtonOk),
              ),
              TextButton(                     
                onPressed: () => Navigator.of(contextDialog).pop(),     
                child: Text(words.dialogButtonCancel),
              ),
            ],
          );
        })           
      }  
    });
    
  }
}