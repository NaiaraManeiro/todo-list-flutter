import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/models.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../pages.dart';

class NewTaskPage extends StatefulWidget {
  static String routeName = "newTask";

  const NewTaskPage({super.key});

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations words = AppLocalizations.of(context)!;
    final categoryProvider = Provider.of<CategoryProvider>(context)..setContext(context);

    // Extracting arguments
    final Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final CardItem item = arguments?['item'];

    return Scaffold(
      appBar: AppBar(
        title: Text(item.nameCategory),
        leading: IconButton(
                icon: Icon(Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios, color: Colors.black,),
                onPressed: () {
                  categoryProvider.logic.clean();
                  Navigator.pushReplacementNamed(context, MainPage.routeName);
                } 
              ),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.check), onPressed: () => categoryProvider.logic.saveTasks())
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(right: 15, left: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView(
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
                children: List.generate(categoryProvider.newTaskList.length, (index) {
                  TaskModel task = categoryProvider.newTaskList.elementAt(index);
                  return ListTile(title: Text(task.name), subtitle: Text("${task.dateIni} / ${task.dateFin}"), leading: Icon(Icons.radio_button_checked_outlined, color: item.color));
                }),
              ),
              const Divider(),
              TextField(
                controller: categoryProvider.textEditingController
                  ..addListener(categoryProvider.logic.editListener),
                autofocus: categoryProvider.newTaskList.isEmpty,
                decoration: InputDecoration(
                  hintText: words.newTask,
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    item.icon,
                    color: item.color,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: categoryProvider.logic.addNewTask,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: categoryProvider.canAddTaskDetail
                          ? item.color
                          : Colors.grey.withOpacity(0.2)
                      ),
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  )
                ),
              ),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Buttons.dateButtons(categoryProvider.logic.getStartTimeText(words), Icons.access_time_outlined, item.color, () => categoryProvider.logic.pickStartTime(words, item.color), true),
                  Buttons.dateButtons(categoryProvider.logic.getEndTimeText(words), Icons.timelapse_outlined, item.color, () => categoryProvider.logic.pickEndTime(words, item.color), categoryProvider.startDate == DateTime(1889) ? false : true),
                ],
              )
            ],
          )
        )
      )
    );
  }
}