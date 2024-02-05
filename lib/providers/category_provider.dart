
import 'package:flutter/material.dart';

import '../logic/logics.dart';
import '../model/models.dart';

class CategoryProvider extends ChangeNotifier {
  late CategoryLogic logic;
  late BuildContext context;

  final TextEditingController textEditingController = TextEditingController();

  List<TaskModel> newTaskList = [];
  late DateTime startDate;
  late DateTime finishDate;
  bool canAddTaskDetail = false;
  
  String newCategory = '';
  final newCategoryKey = GlobalKey<FormState>();
  bool isNewCategoryOk = false;
  Color currentColor = Colors.black;
  IconData selectedIcon = Icons.highlight_off_outlined;

  CategoryProvider(){
    logic = CategoryLogic(this);
    startDate = DateTime(1889);
    finishDate = DateTime(1889);
  }

  void setContext(BuildContext context) async {
    this.context = context;
  }

  void refresh() {
    notifyListeners();
  }

  @override
  void dispose(){
    super.dispose();
    textEditingController.removeListener(logic.editListener);
    textEditingController.dispose();
  }
}