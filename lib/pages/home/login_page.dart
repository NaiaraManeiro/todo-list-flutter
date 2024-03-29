import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../providers/providers.dart';
import '../../ui/uis.dart';
import '../../assets/constants.dart' as constants;
import '../pages.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "login";

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => __LoginPageState();
}

class __LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) { 
    AppLocalizations words = AppLocalizations.of(context)!;
    final loginForm = Provider.of<LoginProvider>(context)..setContext(context);

    //SQLHelper.cleanDatabase();

    Locale newLocale = const Locale('es', 'ES');

    return Scaffold(
      appBar: AppBar(
        title: Text(words.singIn),
      ),
      body: Container(
        margin: const EdgeInsets.only(right: 30, left: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      newLocale = const Locale('es', 'ES');
                      Get.updateLocale(newLocale);
                      SharedPrefHelper.setString(constants.languageCode, newLocale.languageCode);
                    }, 
                    child: const Text('ES', style: TextStyle(fontWeight: FontWeight.bold))
                  ),
                  const Text('|', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      newLocale = const Locale('en', 'EN');
                      Get.updateLocale(newLocale);
                      SharedPrefHelper.setString(constants.languageCode, newLocale.languageCode);
                    }, 
                    child: const Text('EN', style: TextStyle(fontWeight: FontWeight.bold))
                  ),   
                ],
              ),
              Form(
                key: loginForm.emailKey,
                child: TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: WidgetDecorations.authInputDecoration(labelText: words.email, prefixIcon: Icons.email),
                  onChanged: (value) => loginForm.email = value,
                  focusNode: loginForm.emailFocusNode..addListener((){
                    if(!loginForm.emailFocusNode.hasFocus){
                     loginForm.emailKey.currentState?.validate();
                    }
                  }),
                  validator: (value) => loginForm.logic.validateEmail(words, value),
                ),
              ),
              Form(
                key: loginForm.passwordKey,
                child: TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  decoration: WidgetDecorations.authInputDecoration(labelText: words.password, prefixIcon: Icons.lock_outline,
                    suffixIcon: TextButton(
                      onPressed: () => loginForm.logic.navigateTo(ForgotPassPage.routeName),
                      child: Text(words.forget),
                    )
                  ),
                  onChanged: (value) => loginForm.password = value,
                    focusNode: loginForm.passwordFocusNode..addListener((){
                      if(!loginForm.passwordFocusNode.hasFocus){
                        loginForm.passwordKey.currentState?.validate();
                      }
                  }),
                  validator: (value) => loginForm.logic.validatePassword(words, value),
                  maxLength: 20,
                )
              ),
              OutlinedButton(
                child: Text(words.singIn),
                onPressed:() {
                  loginForm.logic.signIn(words, loginForm.email, loginForm.password);
                },
              ),
              TextButton(
                child: Text(words.noAccount),
                onPressed:() => loginForm.logic.navigateTo(RegisterPage.routeName),
              ),
              const SizedBox(height: 15,),
              InkWell(
                child: const Icon(Icons.fingerprint, size: 45,),
                onTap: () => loginForm.bioLogic.authenticate(words),
              )              
            ]
          )
        )
      )
    );
  }
}