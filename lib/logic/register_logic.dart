
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/providers.dart';

class RegisterLogic{

  final RegisterProvider _provider;

  RegisterLogic(this._provider);

  void onSubmit(){

  }

  String? validateEmail(AppLocalizations words, String? email) {
    String pattern = r'[a-zA-Z0-9._-]+@[a-z]+\.+[a-z]+';
    RegExp regExp  = RegExp(pattern);

    if (!regExp.hasMatch(email ?? '')) {
      return words.badEmail;
    } else {
      _provider.refresh();
      return null;
    }
  }

  String? validateUsername(AppLocalizations words, String? username) {
    String pattern = r'^(?=.*[0-9])(?=.*[a-z-A-Z]).{5,20}$';
    RegExp regExp  = RegExp(pattern);
    
    if (!regExp.hasMatch(username ?? '')) {
      return words.badUsername;
    } else {
      _provider.refresh();
      return null;
    }
  }

  String? validatePassword(AppLocalizations words, String? password) {
    String pattern = r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=()-]).{8,20}$';
    RegExp regExp  = RegExp(pattern);

    if (!regExp.hasMatch(password ?? '')) {
      return words.badPassword;
    } else {
      _provider.refresh();
      return null;
    }
  }

  String? validateConfirmationPass(AppLocalizations words, String? password, String? confirmationPass) {
    return password == confirmationPass
      ? null
      : words.passwordsNotMatch;
  }
}