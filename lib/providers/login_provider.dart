import 'package:flutter/material.dart';

import '../logic/logics.dart';

class LoginProvider extends ChangeNotifier {
  late LoginLogic logic;
  late BiometricLogic bioLogic;
  late BuildContext context;

  String email = '';
  String password = '';

  bool isEmailOk = false;
  bool isPasswordOk = false;

  final emailKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

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
  }

  void refresh(){
    notifyListeners();
  }
}