import 'package:flutter/material.dart';

class CardItem {
  late IconData icon;
  late MaterialColor color;
  late String nameCategory;
  late String totalTareas;
  late int totalProgress;
  late String totalTime;
  CardItem(this.icon, this.color, this.nameCategory, this.totalTareas, this.totalProgress, this.totalTime);
}