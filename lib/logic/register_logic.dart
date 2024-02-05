
import 'dart:math';

import 'package:email_sender/email_sender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:todo_list_flutter/model/models.dart';

import '../helpers/helpers.dart';
import '../pages/pages.dart';
import '../providers/providers.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class RegisterLogic{

  final RegisterProvider _provider;

  RegisterLogic(this._provider);


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

  String? validateUsername(AppLocalizations words, String? username) {
    _provider.isUserNameOk = false;
    String pattern = r'^(?=.*[0-9])(?=.*[a-z-A-Z]).{5,20}$';
    RegExp regExp  = RegExp(pattern);
    
    if (!regExp.hasMatch(username ?? '')) {
      return words.badUsername;
    } else {
      _provider.isUserNameOk = true;
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

  String? validateConfirmationPass(AppLocalizations words, String? password, String? confirmationPass) {
    _provider.isRePasswordOk = false;
    if (password == confirmationPass) {
      _provider.isRePasswordOk = true;
      _provider.refresh();
      return null;
    } else {
      return words.passwordsNotMatch;
    }
  }

  String? validateCode(AppLocalizations words, String? code) {
    _provider.isCodeOk = false;
    String pattern = r'^[0-9]{6}$';
    RegExp regExp  = RegExp(pattern);
    
    if (!regExp.hasMatch(code ?? '')) {
      return words.badCode;
    } else if (code != _provider.code.toString()){
      return words.incorrectCode;
    } else {
      _provider.isCodeOk = true;
      _provider.refresh();
      return null;
    }
  }

  void onSubmit(AppLocalizations words) async {
    if (!_provider.isEmailOk || !_provider.isUserNameOk || !_provider.isPasswordOk || !_provider.isRePasswordOk) {
      ShowDialogs.showNormalDialog(words.dialogAlertTitle, words.incorrectInputs, _provider.context);
      return;
    }

    //First check if the user already exists
    UserModel? user = await SQLHelper.checkUserExists(_provider.email);

    if (user != null) {
      //the user already exists (the email is already saved)
      ShowDialogs.showNormalDialog(words.dialogAlertTitle, words.userExists, _provider.context);
      return;
    } else {
      final encryptPassword = EncryptUtil.instance.encrypt(_provider.password);

      //register new user
      final id = await SQLHelper.insertNewUser(words, _provider.email, _provider.username, encryptPassword);

      if (id == -1) {
        //register fail
        ShowDialogs.showNormalDialog(words.dialogAlertTitle, words.dialogRegisterFailText, _provider.context);
      } else {
        Get.snackbar(words.dialogRegisterOkText, "", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.black87, colorText: Colors.white);
        Navigator.pushReplacementNamed(_provider.context, LoginPage.routeName);
      }

    }
  }

  Future<void> sendCode(AppLocalizations words) async {
    Random random = Random();
    // Generate a random number between 100000 and 999999 (6 digits)
    _provider.code = random.nextInt(900000) + 100000;
    EmailSender emailsender = EmailSender();
    var response = await emailsender.sendOtp(_provider.email, _provider.code);
    print("Email send $response");
  }
}