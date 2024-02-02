import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'helpers/helpers.dart';
import 'pages/pages.dart';
import 'providers/providers.dart';
import '../assets/constants.dart' as constants;

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RegisterProvider(), lazy: false,),
          ChangeNotifierProvider(create: (_) => LoginProvider(), lazy: false,),
          ChangeNotifierProvider(create: (_) => ForgotPassProvider(), lazy: false,),
          ChangeNotifierProvider(create: (_) => MainPageProvider(), lazy: false,),
          ChangeNotifierProvider(create: (_) => CategoryProvider(), lazy: false,),
          ChangeNotifierProvider(create: (_) => TaskProvider(), lazy: false,),
        ],
        child: const MyApp(),
      );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
      super.initState();
      SharedPrefHelper.getString(constants.languageCode).then((value) => 
        setState(() {
          if(value != ''){
            String countryCode = "EN";
            if (value == "es") {
              countryCode = "ES";
            }
            Get.updateLocale(Locale(value, countryCode));
          } else {
            Get.updateLocale(Get.deviceLocale!);
          }
        })
      );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo List App',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'EN'),
        Locale('es', 'ES'),
      ],
      debugShowCheckedModeBanner: false,
      initialRoute: SplashPage.routeName,
      routes: {
        SplashPage.routeName: (_) => const SplashPage(),
        RegisterPage.routeName: (_) => const RegisterPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        ForgotPassPage.routeName: (_) => const ForgotPassPage(),
        MainPage.routeName: (_) => const MainPage(),
        NewTaskPage.routeName: (_) => const NewTaskPage(),
        InfoCategoryPage.routeName: (_) => const InfoCategoryPage(),
      },
    );
  }
}
