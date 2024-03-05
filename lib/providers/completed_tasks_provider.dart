
import 'package:flutter/material.dart';

import '../logic/logics.dart';
import '../model/models.dart';

class CompletedTasksProvider extends ChangeNotifier {
  late CompletedTasksLogic logic;
  late BuildContext context;

  List<CardItem>? doneTasks; 
  List<CardItem>? copyList; 
  List<bool>? selectedCategories; 
  DateTime? startDate;
  DateTime? endDate;

  CompletedTasksProvider() {
    logic = CompletedTasksLogic(this);
  }

  void setContext(BuildContext context) async {
    this.context = context;

    doneTasks = await logic.getDoneTasks();
    copyList = copyList ?? doneTasks;
    selectedCategories = selectedCategories ?? 
      (doneTasks == null
        ? []
        : List.filled(doneTasks!.length, true));
    
    refresh();
  }

  void refresh(){
    notifyListeners();
  }
}