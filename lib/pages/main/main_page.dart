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
        child: Column(
          children: [
            Center(
              child: Text(words.mainHello(mainProvider.logUser ?? ""), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
            ),
            const SizedBox(height: 5,),
            mainProvider.userCategories == null 
              ? Column(
                 children: [
                  Text(words.mainNoCategories),
                  const SizedBox(height: 80,),
                  const Icon(Icons.add_task_outlined, size: 100,)
                 ]
                )
              : Column(
                 children: [
                  Text(words.mainYesCategories),
                  const SizedBox(height: 30,),
                  CarouselSlider(
                    items: mainProvider.logic.getCards(context),
                    options: CarouselOptions(
                      aspectRatio: 16 / 9,
                      height: min(size.width, size.height) - 110,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                    ),
                  )
                ]
              )
          ]
        ) 
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation:
        FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const CircleListFloatingButton()
    );
  }
}