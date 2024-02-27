import 'package:flutter/material.dart';

import '../logic/logics.dart';
import '../model/models.dart';

class MainPageProvider extends ChangeNotifier {
  late MainPageLogic logic;
  late BuildContext context;
  List<CardItem>? userCategories = [];
  List<CardItem>? categories = [];
  CardItem? selectedCategory;
  String? logUser;
  int? categoryMaxValue;
  int? categoryMinValue;

  MainPageProvider(){
    logic = MainPageLogic(this);
  }

  void setContext(BuildContext context) async {
    this.context = context;

    List<Future> tasks = [
      logic.getUserCategories(context),
      logic.getCategories(),
      logic.getUserName(),
      logic.getCategoryMaxValue(),
      logic.getCategoryMinValue(),
    ];

    List results = await Future.wait(tasks);

    userCategories = results[0];
    categories = results[1];
    logUser = results[2];
    categoryMaxValue = results[3];
    categoryMinValue = results[4];
    
    refresh();
  }

  void refresh() {
    notifyListeners();
  }
}