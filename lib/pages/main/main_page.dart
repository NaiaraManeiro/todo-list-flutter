import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final size = MediaQuery.of(context).size;

    CardItem item = CardItem(Icons.directions_run_outlined, Colors.green, "Sports", "0 items", "0.5", "23 horas");
    CardItem item2 = CardItem(Icons.flight_outlined, Colors.blue, "Travel", "1 item", "0.25", "5 horas");

    return Scaffold(
      appBar: AppBar(
        title: Text(words.mainTitle),
      ),
      endDrawer: CustomDrawer.getDrawer(context),
      body: Container(
        margin: const EdgeInsets.only(top: 40, bottom: 40),
        child: CarouselSlider(
          items: [CategoryCard.getCategoryCard(context, item),CategoryCard.getCategoryCard(context, item2)],
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