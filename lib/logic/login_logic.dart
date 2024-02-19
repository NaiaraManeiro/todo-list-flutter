import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_list_flutter/helpers/helpers.dart';

import '../model/models.dart';
import '../pages/pages.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../ui/uis.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import '../assets/constants.dart' as constants;

class LoginLogic {

  final LoginProvider _provider;

  LoginLogic(this._provider);


  String? validateEmail(AppLocalizations words, String? email) {
    _provider.isEmailOk = false;
    String pattern = r'[a-zA-Z0-9._-]+@[a-z]+\.+[a-z]+';
    RegExp regExp  = RegExp(pattern);

    if (!regExp.hasMatch(email ?? '')) {
      return words.badEmail;
    } else {
      _provider.isEmailOk = true;
      _provider.refresh();
      return null;
    }
  }

  String? validatePassword(AppLocalizations words, String? password) {
    _provider.isPasswordOk = false;
    String pattern = r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=()-]).{8,20}$';
    RegExp regExp  = RegExp(pattern);

    if (!regExp.hasMatch(password ?? '')) {
      return words.badPassword;
    } else {
      _provider.isPasswordOk = true;
      _provider.refresh();
      return null;
    }
  }

  String? validatePin(AppLocalizations words, String? value, BuildContext contextDialog) {
    String pattern = r'^[0-9]{6}$';
    RegExp regExp  = RegExp(pattern);

    _provider.isPinOk = false;
    if (!regExp.hasMatch(value ?? '')) {
      return words.badCode;
    } else if (_provider.generatedPin != value) {
      return words.wrongPin;
    } else {
      _provider.isPinOk = true;
      return null;
    }
  }

  void signIn(AppLocalizations words, String email, String password) async {
    //Check if the user exist
    UserModel? user = await SQLHelper.checkUserExists(email);

    if (user == null) {
      //The email does not exist
      ShowDialogs.showButtonDialog(words.dialogAlertTitle, words.userNoExists, words.singUp, _provider.context, () => Navigator.pushReplacementNamed(_provider.context, RegisterPage.routeName));
    } else {
      //Check if the password is correct
      final savedPass = EncryptUtil.instance.decrypt(user.password);
      if (savedPass != password) {
        ShowDialogs.showNormalDialog(words.dialogAlertTitle, words.incorrectPass, _provider.context);
        return;
      } else {
        loginOTP(words);
        SharedPrefHelper.setString(constants.email, email);
      }
    }
  }

  void loginOTP(AppLocalizations words) {
    NotificationService().init().then((value) => _provider.generatedPin = value);

    showDialog(context: _provider.context, builder: (BuildContext contextDialog) { 
      return AlertDialog(
        title: Text(words.pinTitle, textAlign: TextAlign.center),        
        content: Wrap(
          children: [ 
            Column(
              children: [
                const SizedBox(height: 5,),
                Text(words.pinText, textAlign: TextAlign.center),
                const SizedBox(height: 5,),
                Form(
                  key: _provider.pinKey,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) => validatePin(words, value, contextDialog),
                    onChanged: (value) {
                      _provider.pinKey.currentState?.validate();
                      _provider.pin = value;
                    },
                    decoration: WidgetDecorations.authInputDecoration(labelText: words.etPin, prefixIcon: Icons.pin),
                  ),
                ),
              ],
            )
          ]
        ), 
        actions: [
          TextButton(                     
            onPressed: () {
             if (_provider.pin == _provider.generatedPin){
              ShowDialogs.showSnackbar(_provider.context, words.loginOk);
              navigateTo(MainPage.routeName);
             } else {
                _provider.tries++;
                if (_provider.tries == 3) {
                  _provider.tries = 0;
                  Navigator.of(contextDialog).pop(); 
                  ShowDialogs.showSnackbar(_provider.context, words.toMuchTries); 
                }
             }
            },     
            child: Text(words.dialogButtonAccept),
          ),
          TextButton(                     
            onPressed: () => {
              _provider.tries = 0,
              Navigator.of(contextDialog).pop(),  
            },   
            child: Text(words.dialogButtonCancel),
          ),
        ],
      );}
    );
  }

  void navigateTo(String route) {
    Navigator.pushReplacementNamed(_provider.context, route);
  }
}