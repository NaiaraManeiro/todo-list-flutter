import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../ui/uis.dart';
import '../pages.dart';

class ForgotPassPage extends StatefulWidget {
  static String routeName = "forgot";

  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations words = AppLocalizations.of(context)!;
    final forgotPassForm = Provider.of<ForgotPassProvider>(context)..setContext(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(words.forgetPass),
        leading: IconButton(
                icon: Icon(Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios, color: Colors.black,),
                onPressed: () => Navigator.pushReplacementNamed(context, LoginPage.routeName),
              ),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.check), onPressed: () => forgotPassForm.logic.onSubmit(words))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(right: 30, left: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: forgotPassForm.emailKey,
                child: TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: WidgetDecorations.authInputDecoration(labelText: words.email, prefixIcon: Icons.email),
                  onChanged: (value) => forgotPassForm.email = value,
                  focusNode: forgotPassForm.emailFocusNode..addListener((){
                    if(!forgotPassForm.emailFocusNode.hasFocus){
                     forgotPassForm.emailKey.currentState?.validate();
                    }
                  }),
                  validator: (value) => forgotPassForm.logic.validateEmail(words, value),
                ),
              ),
              const SizedBox(height: 25),
              Form(
                key: forgotPassForm.codeKey,
                child: TextFormField(
                  autocorrect: false,
                  decoration: WidgetDecorations.authInputDecoration(labelText: words.verifyCode, prefixIcon: Icons.message_outlined, 
                    suffixIcon: TextButton(
                      onPressed: () => forgotPassForm.logic.sendCode(words),
                      child: Text(words.btnVerifyCode),
                   )
                  ),
                  onChanged: (value) => forgotPassForm.code = value,
                    focusNode: forgotPassForm.codeFocusNode..addListener((){
                      if(!forgotPassForm.codeFocusNode.hasFocus){
                        forgotPassForm.codeKey.currentState?.validate();
                      }
                  }),
                  validator: (value) => forgotPassForm.logic.validateCode(words, value),
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                )
              ),
              Form(
                key: forgotPassForm.passwordKey,
                child: TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  decoration: WidgetDecorations.authInputDecoration(labelText: words.newPassword, prefixIcon: Icons.lock_outline),
                  onChanged: (value) => forgotPassForm.password = value,
                  focusNode: forgotPassForm.passwordFocusNode..addListener((){
                    if(!forgotPassForm.passwordFocusNode.hasFocus){
                     forgotPassForm.passwordKey.currentState?.validate();
                    }
                  }),
                  validator: (value) => forgotPassForm.logic.validatePassword(words, value),
                  maxLength: 20,
                ),
              ),
              Form(
                key: forgotPassForm.rePasswordKey,
                child: TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  decoration: WidgetDecorations.authInputDecoration(labelText: words.confirmPass, prefixIcon: Icons.lock),
                  onChanged: (value) => forgotPassForm.confirmPassword = value,
                  focusNode: forgotPassForm.rePasswordFocusNode..addListener((){
                    if(!forgotPassForm.rePasswordFocusNode.hasFocus){
                     forgotPassForm.rePasswordKey.currentState?.validate();
                    }
                  }),
                  validator: (value) => forgotPassForm.logic.validateConfirmationPass(words, forgotPassForm.password, value),
                  maxLength: 20,
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}