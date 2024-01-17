import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../ui/uis.dart';

class RegisterPage extends StatefulWidget {
  static String routeName = "register";

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => __RegisterPageState();
}

class __RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations words = AppLocalizations.of(context)!;
    final registerForm = Provider.of<RegisterProvider>(context)..setContext(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(words.singUp),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.check), onPressed: () => registerForm.logic.onSubmit(words))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(right: 30, left: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: registerForm.emailKey,
                child: TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecorations.authInputDecoration(labelText: words.email, prefixIcon: Icons.email),
                  onChanged: (value) => registerForm.email = value,
                  focusNode: registerForm.emailFocusNode..addListener((){
                    if(!registerForm.emailFocusNode.hasFocus){
                     registerForm.emailKey.currentState?.validate();
                    }
                  }),
                  validator: (value) => registerForm.logic.validateEmail(words, value),
                ),
              ),
              const SizedBox(height: 25),
              Form(
                key: registerForm.userNameKey,
                child: TextFormField(
                  autocorrect: false,
                  decoration: InputDecorations.authInputDecoration(labelText: words.username, prefixIcon: Icons.person),
                  onChanged: (value) => registerForm.username = value,
                  focusNode: registerForm.userNameFocusNode..addListener((){
                    if(!registerForm.userNameFocusNode.hasFocus){
                     registerForm.userNameKey.currentState?.validate();
                    }
                  }),
                  validator: (value) => registerForm.logic.validateUsername(words, value),
                  maxLength: 20,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              Form(
                key: registerForm.passwordKey,
                child: TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecorations.authInputDecoration(labelText: words.password, prefixIcon: Icons.lock_outline),
                  onChanged: (value) => registerForm.password = value,
                  focusNode: registerForm.passwordFocusNode..addListener((){
                    if(!registerForm.passwordFocusNode.hasFocus){
                     registerForm.passwordKey.currentState?.validate();
                    }
                  }),
                  validator: (value) => registerForm.logic.validatePassword(words, value),
                  maxLength: 20,
                ),
              ),
              Form(
                key: registerForm.rePasswordKey,
                child: TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecorations.authInputDecoration(labelText: words.confirmPass, prefixIcon: Icons.lock),
                  onChanged: (value) => registerForm.confirmPassword = value,
                  focusNode: registerForm.rePasswordFocusNode..addListener((){
                    if(!registerForm.rePasswordFocusNode.hasFocus){
                     registerForm.rePasswordKey.currentState?.validate();
                    }
                  }),
                  validator: (value) => registerForm.logic.validateConfirmationPass(words, registerForm.password, value),
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