
import 'package:flutter/material.dart';

import '../logic/logics.dart';
import '../model/models.dart';

class CompletedTasksProvider extends ChangeNotifier {
  late CompletedTasksLogic logic;
  late BuildContext context;

  List<CardItem>? doneTasks; 
  List<CardItem>? copyList; 
  List<bool>? selectedCategories; 

  CompletedTasksProvider() {
    logic = CompletedTasksLogic(this);
  }

  void setContext(BuildContext context) async {
    this.context = context;

    doneTasks = await logic.getDoneTasks();
    copyList = copyList ?? doneTasks;
    selectedCategories = selectedCategories ?? List.filled(doneTasks!.length, true);
    
    refresh();
  }

  void refresh(){
    notifyListeners();
  }
}