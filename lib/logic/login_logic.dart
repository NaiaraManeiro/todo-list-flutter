import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:todo_list_flutter/helpers/helpers.dart';

import '../model/models.dart';
import '../pages/pages.dart';
import '../providers/providers.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import '../assets/constants.dart' as constants;

class LoginLogic{

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

  void signIn(AppLocalizations words, String email, String password) async {
    //Check if the user exist
    UserModel? user = await SQLHelper.checkUserExists(email);

    if (user == null) {
      //The email does not exist
      ShowDialogs.showButtonDialog(words.dialogAlertTitle, words.userNoExists, words.singUp, _provider.context);
    } else {
      //Check if the password is correct
      final savedPass = EncryptUtil().decrypt(user.password);
      if (savedPass != password) {
        ShowDialogs.showNormalDialog(words.dialogAlertTitle, words.incorrectPass, _provider.context);
        return;
      } else {
        SharedPrefHelper.setString(constants.email, email);
        Get.snackbar("Successful registration", words.dialogRegisterOkText, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.black87, colorText: Colors.white);
        Navigator.pushReplacementNamed(_provider.context, MainPage.routeName);
      }
    }
  }

  void navigateToRegister() {
    Navigator.pushReplacementNamed(_provider.context, RegisterPage.routeName);
  }
}