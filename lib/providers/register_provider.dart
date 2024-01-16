import 'package:flutter/material.dart';

import '../logic/logics.dart';

class RegisterProvider extends ChangeNotifier {
  late RegisterLogic logic;
  late BuildContext context;

  String email = '';
  String username = '';
  String password = '';
  String confirmPassword = '';

  final emailKey = GlobalKey<FormState>();
  final userNameKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();
  final rePasswordKey = GlobalKey<FormState>();

  final emailFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final rePasswordFocusNode = FocusNode();

  bool _isLoading = false;
  bool get isLoading => _isLoading; 
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  } 

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
  }

  void refresh(){
    notifyListeners();
  }
}