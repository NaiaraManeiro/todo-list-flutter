
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../model/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

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

  void saveTasks() {

  }

  void addNewTask() {
    final controller = _provider.textEditingController;
    String text = controller.text;
    if (text.isEmpty || (_provider.startDate == DateTime(1889) && _provider.finishDate != DateTime(1889)) 
      || (_provider.startDate != DateTime(1889) && _provider.finishDate == DateTime(1889))) return;
    _provider.newTaskList.add(TaskModel(text, DateFormat('dd-MM-yyyy').format(_provider.startDate).toString(), 
      DateFormat('dd-MM-yyyy').format(_provider.finishDate).toString(), '0'));
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

  void clean() {
    _provider.canAddTaskDetail = false;
    _provider.newTaskList = [];
    _provider.startDate = DateTime(1889);
    _provider.finishDate = DateTime(1889);
    _provider.refresh();
  }
}