
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../helpers/helpers.dart';
import '../model/models.dart';
import '../pages/pages.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import '../../assets/constants.dart' as constants;

class CategoryLogic {

  final CategoryProvider _provider;

  CategoryLogic(this._provider);

  void editListener() {
    final text = _provider.textEditingController.text;
    if (text.isEmpty && _provider.canAddTaskDetail && (_provider.startDate == DateTime(1889) || _provider.finishDate == DateTime(1889))) {
      _provider.canAddTaskDetail = false;
      _provider.refresh();
    } else if (text.isNotEmpty && !_provider.canAddTaskDetail && _provider.startDate != DateTime(1889) && _provider.finishDate != DateTime(1889)) {
      _provider.canAddTaskDetail = true;
      _provider.refresh();
    }
  }

  Future<void> saveTasks(String nameCategory, bool newC) async {
    final email = await SharedPrefHelper.getString(constants.email);
    await SQLHelper.addTasks(email, nameCategory, _provider.newTaskList, newC);
    _provider.logic.clean();
    Navigator.pushReplacementNamed(_provider.context, MainPage.routeName); 
  }

  void addNewTask(int index) {
    final controller = _provider.textEditingController;
    String text = controller.text;
    if (text.isEmpty || (_provider.startDate == DateTime(1889) && _provider.finishDate != DateTime(1889)) 
      || (_provider.startDate != DateTime(1889) && _provider.finishDate == DateTime(1889))) return;

    if (index == -1) {
      _provider.newTaskList.add(TaskModel(id: 0, name: text, dateIni: DateFormat('dd-MM-yyyy').format(_provider.startDate).toString(), 
      dateFin: DateFormat('dd-MM-yyyy').format(_provider.finishDate).toString(), progress: 0));
    } else{
      TaskModel updatedTask = _provider.newTaskList[index].copyWith(
        name: text,
        dateIni: DateFormat('dd-MM-yyyy').format(_provider.startDate).toString(),
        dateFin: DateFormat('dd-MM-yyyy').format(_provider.finishDate).toString()
      );
      _provider.newTaskList[index] = updatedTask;
    }
    
    controller.clear();
    _provider.refresh();
  }

  String getStartTimeText(AppLocalizations words) {
    if (_provider.startDate != DateTime(1889)) {
      final time = _provider.startDate;
      final day = time.day.toString().padLeft(2, '0');
      final month = time.month.toString().padLeft(2, '0');
      return "$day-$month-${time.year}";
    }
    return words.startDate;
  }

  String getEndTimeText(AppLocalizations words) {
    if (_provider.finishDate != DateTime(1889)) {
      final time = _provider.finishDate;
      final day = time.day.toString().padLeft(2, '0');
      final month = time.month.toString().padLeft(2, '0');
      return "$day-$month-${time.year}";
    }
    return words.endDate;
  }

  void pickStartTime(AppLocalizations words, Color color) {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = initialDate.add(const Duration(days: 1));
    DateTime lastDate = initialDate.add(const Duration(days: 365));
    showDatePicker(
      context: _provider.context, 
      firstDate: firstDate, 
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: color,
            hintColor: color, 
            colorScheme: ColorScheme.light(primary: color),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    ).then((value) => {
      if (value != null) {
        if (_provider.finishDate != DateTime(1889) && _provider.finishDate.isBefore(value)) {
          ShowDialogs.showNormalDialog(words.dialogAlertTitle, words.dialogWrongDateText, _provider.context)
        } else {
          _provider.startDate = value,
          _provider.refresh()
        }
      }
    });
  }

  void pickEndTime(AppLocalizations words, Color color) {
    DateTime initialDate = _provider.startDate;
    DateTime firstDate = initialDate.add(const Duration(days: 1));
    DateTime lastDate = initialDate.add(const Duration(days: 365));
    showDatePicker(
      context: _provider.context, 
      firstDate: firstDate, 
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: color,
            hintColor: color, 
            colorScheme: ColorScheme.light(primary: color),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    ).then((value) => {
      if (value != null) {
        if (_provider.startDate != DateTime(1889) && _provider.startDate.isAfter(value)) {
          ShowDialogs.showNormalDialog(words.dialogAlertTitle, words.dialogWrongDateText, _provider.context)
        } else {
          _provider.finishDate = value,
          _provider.refresh()
        }
      }
    });
  }

  void deleteTask(int index) async {
    _provider.newTaskList.removeAt(index);
    _provider.refresh();
  }

  String? validateCategory(AppLocalizations words, String? category) {
    _provider.isNewCategoryOk = false;
    String pattern = r'[a-zA-Z]{1,20}';
    RegExp regExp  = RegExp(pattern);

    if (!regExp.hasMatch(category ?? '')) {
      return words.badEmail;
    } else {
      _provider.isNewCategoryOk = true;
      _provider.refresh();
      return null;
    }
  }

  void newCategory(AppLocalizations words) async {
    if (!_provider.isNewCategoryOk) {
      ShowDialogs.showNormalDialog(words.dialogAlertTitle, words.newCatIncorrect, _provider.context);
      return;
    }

    final email = await SharedPrefHelper.getString(constants.email);
    CardItem category = CardItem(_provider.selectedIcon, MaterialColorHelper.getMaterialColor(_provider.currentColor.value), _provider.newCategory, "0", 0, "0", []);

    String error = await SQLHelper.addCategoryUser(email, category);

    if (error == "KO") {
      ShowDialogs.showNormalDialog(words.dialogAlertTitle, words.categoryExists, _provider.context);
    } else {
      ShowDialogs.showSnackbar(_provider.context, words.newCatCreated);
      Navigator.pushReplacementNamed(_provider.context, MainPage.routeName);
    }
  }

  void updateCategory(AppLocalizations words, CardItem item, List<TaskModel> tasks) async {
    if (!_provider.isNewCategoryOk) {
      ShowDialogs.showNormalDialog(words.dialogAlertTitle, words.newCatIncorrect, _provider.context);
      return;
    }

    final email = await SharedPrefHelper.getString(constants.email);
    String nameCategory =  item.nameCategory;
    
    item.nameCategory = _provider.newCategory;
    item.color = MaterialColorHelper.getMaterialColor(_provider.currentColor.value);
    item.icon = _provider.selectedIcon;

    await SQLHelper.editCategoryUser(email, item, nameCategory);

    Navigator.pushReplacementNamed(_provider.context, NewTaskPage.routeName, 
      arguments: {
        'item': item,
        'tasks': tasks
      }
    );
  }

  void setData(CardItem item) {
    _provider.newCategoryController.text = item.nameCategory;
    _provider.isNewCategoryOk = true;
    _provider.currentColor = item.color;
    _provider.selectedIcon = item.icon;
  }

  void cleanData() {
    _provider.newCategoryController.text = "";
    _provider.isNewCategoryOk = false;
    _provider.currentColor = Colors.black;
    _provider.selectedIcon = Icons.highlight_off_outlined;
  }

  void clean() {
    _provider.canAddTaskDetail = false;
    _provider.newTaskList = [];
    _provider.startDate = DateTime(1889);
    _provider.finishDate = DateTime(1889);
    _provider.refresh();
  }
}