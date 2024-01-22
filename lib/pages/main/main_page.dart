import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class MainPage extends StatefulWidget {
  static String routeName = "main";

  const MainPage({super.key});

  @override
  State<MainPage> createState() => __MainPageState();
}

class __MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations words = AppLocalizations.of(context)!;
    final mainProvider = Provider.of<MainPageProvider>(context)..setContext(context);

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(words.mainTitle),
      ),
      endDrawer: CustomDrawer.getDrawer(context),
      body: Container(
        margin: const EdgeInsets.only(top: 40, bottom: 40),
        child: mainProvider.categories == null 
          ? Container(child: Text("Empty"),)
          : CarouselSlider(
          items: mainProvider.logic.getCards(context),
          options: CarouselOptions(
            aspectRatio: 16 / 9,
            height: min(size.width, size.height) - 110,
            initialPage: 0,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
          ),
        ) 
      )
    );
  }
}