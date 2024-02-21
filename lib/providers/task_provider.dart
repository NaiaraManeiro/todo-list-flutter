import 'package:flutter/material.dart';

import '../logic/logics.dart';
import '../model/models.dart';

class TaskProvider extends ChangeNotifier {
  late TaskLogic logic;
  late BuildContext context;

  List<TaskModel> tasks = [];
  String nameCategory = "";

  TaskProvider(){
    logic = TaskLogic(this);
  }

  void setContext(BuildContext context, String nameCategoryN) async {
    this.context = context;
    if (tasks.isEmpty || nameCategory != nameCategoryN) {
      nameCategory = nameCategoryN;
      tasks = await logic.getTasks(nameCategoryN);
      refresh();
    }
  }

  void refresh() {
    notifyListeners();
  }
}