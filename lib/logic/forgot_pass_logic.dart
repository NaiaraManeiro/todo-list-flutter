
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

class ForgotPassLogic{

  final ForgotPassProvider _provider;

  ForgotPassLogic(this._provider);


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

  String? validateCode(AppLocalizations words, String? code) {
    _provider.isCodeOk = false;
    String pattern = r'^[0-9]{6}$';
    RegExp regExp  = RegExp(pattern);
    
    if (!regExp.hasMatch(code ?? '')) {
      return words.badCode;
    } else if (code != _provider.sendCode.toString()){
      return words.incorrectCode;
    } else {
      _provider.isCodeOk = true;
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

  void onSubmit(AppLocalizations words) async {
    if (!_provider.isEmailOk || !_provider.isCodeOk || !_provider.isPasswordOk || !_provider.isRePasswordOk) {
      ShowDialogs.showNormalDialog(words.dialogAlertTitle, words.incorrectInputs, _provider.context);
      return;
    }

    final encryptPassword = EncryptUtil.instance.encrypt(_provider.password);

    int i = await SQLHelper.changePass(_provider.email, encryptPassword);
    if (i > 0) ShowDialogs.showSnackbar(_provider.context, words.changePassOk);
    Navigator.pushReplacementNamed(_provider.context, LoginPage.routeName);
  }

  Future<void> sendCode(AppLocalizations words) async {
    //First check if the email already exists
    UserModel? user = await SQLHelper.checkUserExists(_provider.email);

    if (user == null) {
      ShowDialogs.showNormalDialog(words.dialogAlertTitle, words.emailNoExists, _provider.context);
    } else {
      
      EmailSender emailsender = EmailSender();
      var response = await emailsender.sendOtp(_provider.email, _provider.sendCode!);
      print("Email send $response");
    }
  }
}