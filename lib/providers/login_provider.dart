import 'package:flutter/material.dart';

import '../logic/logics.dart';

class LoginProvider extends ChangeNotifier {
  late LoginLogic logic;
  late BiometricLogic bioLogic;
  late BuildContext context;

  String email = '';
  String password = '';
  String pin = '';

  bool isEmailOk = false;
  bool isPasswordOk = false;
  bool isPinOk = false;

  final emailKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();
  final pinKey = GlobalKey<FormState>();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final pinFocusNode = FocusNode();

  String? generatedPin;
  int tries = 0;

  LoginProvider(){
    logic = LoginLogic(this);
    bioLogic = BiometricLogic(this);
  }

  void setContext(BuildContext context){
    this.context = context;
  }

  @override
  void dispose(){
    disposeNode();
    super.dispose();
  }

  void disposeNode(){
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    pinFocusNode.dispose();
  }

  void refresh(){
    notifyListeners();
  }
}