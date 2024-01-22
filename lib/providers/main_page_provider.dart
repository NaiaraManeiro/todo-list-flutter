
import 'package:flutter/material.dart';

import '../logic/logics.dart';
import '../widgets/widgets.dart';

class MainPageProvider extends ChangeNotifier {
  late MainPageLogic logic;
  late BuildContext context;
  List<CardItem>? userCategories = [];
  List<CardItem>? categories = [];

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