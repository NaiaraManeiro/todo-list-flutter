import 'package:flutter/material.dart';

import '../logic/logics.dart';
import '../model/models.dart';

class TaskProvider extends ChangeNotifier {
  late TaskLogic logic;
  late BuildContext context;

  List<TaskModel> tasks = [];

  TaskProvider(){
    logic = TaskLogic(this);
  }

  void setContext(BuildContext context, String nameCategory) async {
    this.context = context;
    tasks = await logic.getTasks(nameCategory);
  }

  void refresh() {
    notifyListeners();
  }
}