import 'package:flutter/material.dart';

import 'models.dart';

class CardItem {
  late IconData icon;
  late MaterialColor color;
  late String nameCategory;
  late String totalTareas;
  late int totalProgress;
  late String totalTime;
  late List<TaskModel> tasks;
  CardItem(this.icon, this.color, this.nameCategory, this.totalTareas, this.totalProgress, this.totalTime, this.tasks);

  static List<TaskModel> parseTasks(Map<String, dynamic> map) {
    final List<String> noteNames = map['noteNames'].split(',');
    final List<String> noteDateIni = map['noteDateIni'].split(',');
    final List<String> noteDateFin = map['noteDateFin'].split(',');

    final List<TaskModel> tasks = [];

    for (int i = 0; i < noteNames.length; i++) {
      tasks.add(TaskModel(id: 0, name: noteNames[i], dateIni: noteDateIni[i], dateFin: noteDateFin[i], progress: 0));
    }

    return tasks;
  }
}