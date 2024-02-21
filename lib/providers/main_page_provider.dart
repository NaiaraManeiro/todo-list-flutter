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

    userCategories = await logic.getUserCategories(context);
    categories = await logic.getCategories();
    logUser = await logic.getUserName();
    categoryMaxValue = await logic.getCategoryMaxValue();
    categoryMinValue = await logic.getCategoryMinValue();
    
    refresh();
  }

  void refresh() {
    notifyListeners();
  }
}