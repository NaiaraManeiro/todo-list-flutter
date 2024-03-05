import 'package:flutter/material.dart';

import '../logic/logics.dart';

class ForgotPassProvider extends ChangeNotifier {
  late ForgotPassLogic logic;
  late BuildContext context;

  String email = '';
  String code = '';
  String password = '';
  String confirmPassword = '';

  bool isCodeOk = false;
  bool isEmailOk = false;
  bool isPasswordOk = false;
  bool isRePasswordOk = false;

  final emailKey = GlobalKey<FormState>();
  final codeKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();
  final rePasswordKey = GlobalKey<FormState>();

  final emailFocusNode = FocusNode();
  final codeFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final rePasswordFocusNode = FocusNode();

  int? sendCode;

  ForgotPassProvider(){
    logic = ForgotPassLogic(this);
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
    codeFocusNode.dispose();
    passwordFocusNode.dispose();
    rePasswordFocusNode.dispose();
  }

  void refresh(){
    notifyListeners();
  }
}