import 'package:flutter/material.dart';

import '../logic/logics.dart';

class RegisterProvider extends ChangeNotifier {
  late RegisterLogic logic;
  late BuildContext context;

  String email = '';
  String username = '';
  String password = '';
  String confirmPassword = '';
  int code = 0;

  bool isUserNameOk = false;
  bool isEmailOk = false;
  bool isPasswordOk = false;
  bool isRePasswordOk = false;
  bool isCodeOk = false;

  final emailKey = GlobalKey<FormState>();
  final userNameKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();
  final rePasswordKey = GlobalKey<FormState>();
  final codeKey = GlobalKey<FormState>();

  final emailFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final rePasswordFocusNode = FocusNode();
  final codeFocusNode = FocusNode();

  RegisterProvider(){
    logic = RegisterLogic(this);
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
    userNameFocusNode.dispose();
    passwordFocusNode.dispose();
    rePasswordFocusNode.dispose();
    codeFocusNode.dispose();
  }

  void refresh(){
    notifyListeners();
  }
}