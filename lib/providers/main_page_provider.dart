
import 'package:flutter/material.dart';

import '../logic/logics.dart';
import '../widgets/widgets.dart';

class MainPageProvider extends ChangeNotifier {
  late MainPageLogic logic;
  late BuildContext context;
  List<CardItem>? categories = [];

  MainPageProvider(){
    logic = MainPageLogic(this);
  }

  void setContext(BuildContext context) async {
    this.context = context;

    categories = await logic.getCategories(context);
    refresh();
  }

  void refresh() {
    notifyListeners();
  }
}