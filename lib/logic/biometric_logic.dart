
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';

import '../helpers/helpers.dart';
import '../model/models.dart';
import '../pages/pages.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import '../assets/constants.dart' as constants;

class BiometricLogic{

  final LoginProvider _provider;
  final LocalAuthentication auth = LocalAuthentication();

  BiometricLogic(this._provider);

  Future<void> authenticate(AppLocalizations words) async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(localizedReason: 'Let OS determine authentication method');
    } on PlatformException catch (e) {
      Get.snackbar("Error", e.message.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.black87, colorText: Colors.white);
      return;
    }

    if(authenticated){
      checkUserExistForBiometric(words);
    }
  }

  checkUserExistForBiometric(AppLocalizations words) {
    SharedPrefHelper.getString(constants.email).then((value) => {
        if(value == "") {
          SharedPrefHelper.getString(constants.email).then((value) => 
              checkUserExist(words, value)
          )
        } else {
            checkUserExist(words, value)
        }
      });
  }

  checkUserExist(AppLocalizations words, String email) async  {
    UserModel? user; 
    await SQLHelper.checkUserExists(email).then((value) => user = value);
    if(user == null) {
      ShowDialogs.showNormalDialog(words.dialogAlertTitle, words.notUserBiometry, _provider.context);
    } else {
      SharedPrefHelper.setString(constants.email, email);
      Navigator.pushReplacementNamed(_provider.context, MainPage.routeName);
    }
  }
}