
import 'package:flutter/material.dart';

import '../logic/logics.dart';
import '../model/models.dart';

class MainPageProvider extends ChangeNotifier {
  late MainPageLogic logic;
  late BuildContext context;
  List<CardItem>? userCategories = [];
  List<CardItem>? categories = [];
  late CardItem selectedCategory;

  MainPageProvider(){
    logic = MainPageLogic(this);
  }

  void setContext(BuildContext context) async {
    this.context = context;

    userCategories = await logic.getUserCategories(context);
    categories = await logic.getCategories();
    refresh();
  }

  void refresh() {
    notifyListeners();
  }
}