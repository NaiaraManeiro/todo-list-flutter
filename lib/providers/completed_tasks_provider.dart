
import 'package:flutter/material.dart';

import '../logic/logics.dart';
import '../model/models.dart';

class CompletedTasksProvider extends ChangeNotifier {
  late CompletedTasksLogic logic;
  late BuildContext context;

  List<CardItem>? doneTasks; 

  CompletedTasksProvider() {
    logic = CompletedTasksLogic(this);
  }

  void setContext(BuildContext context) async {
    this.context = context;

    doneTasks = await logic.getDoneTasks();
    
    refresh();
  }

  void refresh(){
    notifyListeners();
  }
}