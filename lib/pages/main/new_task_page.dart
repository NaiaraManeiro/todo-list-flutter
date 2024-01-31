import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
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
  String buttonStartTime = "";
  String buttonFinalTime = "";
  int id = -1;
  List<TaskModel> tasks = [];

  @override
  Widget build(BuildContext context) {
    AppLocalizations words = AppLocalizations.of(context)!;
    final categoryProvider = Provider.of<CategoryProvider>(context)..setContext(context);

    // Extracting arguments
    final Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final CardItem item = arguments?['item'];
    List<TaskModel> tasksA = arguments?['tasks'].cast<TaskModel>().toList();
    if (tasks.isEmpty && tasksA.isNotEmpty) {
      categoryProvider.newTaskList = tasksA;
      tasks = arguments?['tasks'].cast<TaskModel>().toList();
    }

    buttonStartTime = categoryProvider.logic.getStartTimeText(words);
    buttonFinalTime = categoryProvider.logic.getEndTimeText(words);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.nameCategory),
        leading: IconButton(
          icon: Icon(Platform.isAndroid
            ? Icons.arrow_back
            : Icons.arrow_back_ios, color: item.color,),
          onPressed: () {
            categoryProvider.logic.clean();
            Navigator.pushReplacementNamed(context, MainPage.routeName);
          } 
        ),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.check), onPressed: () => categoryProvider.logic.saveTasks(item.nameCategory))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 10),
                shrinkWrap: true,
                children: List.generate(categoryProvider.newTaskList.length, (index) {
                  TaskModel task = categoryProvider.newTaskList.elementAt(index);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.radio_button_checked_outlined, color: item.color),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task.name, style: const TextStyle(fontWeight: FontWeight.bold),),
                            Text("${task.dateIni} / ${task.dateFin}", style: const TextStyle(fontWeight: FontWeight.w300))
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  id = index;
                                  buttonStartTime = categoryProvider.newTaskList[index].dateIni;
                                  List<String> startTime = buttonStartTime.split('-');
                                  categoryProvider.startDate = DateTime(int.parse(startTime[2]), int.parse(startTime[1]), int.parse(startTime[0]));
                                  buttonFinalTime = categoryProvider.newTaskList[index].dateFin;
                                  List<String> endTime = buttonFinalTime.split('-');
                                  categoryProvider.finishDate = DateTime(int.parse(endTime[2]), int.parse(endTime[1]), int.parse(endTime[0]));
                                  categoryProvider.textEditingController.text = categoryProvider.newTaskList[index].name;
                                });
                              }, 
                              icon: const Icon(Icons.edit_outlined, color: Colors.green,), 
                            ),
                            IconButton(
                              onPressed: () {
                                ShowDialogs.showButtonDialog(words.dialogAlertTitle, words.dialogDeleteTaskText, words.dialogDeleteTaskButtonOk, context, 
                                () {
                                  Navigator.of(context).pop();
                                  categoryProvider.logic.deleteTask(index);
                                  }
                                );
                              }, 
                              icon: const Icon(Icons.delete_outlined, color: Colors.red,), 
                            )
                          ]
                        )
                      ],
                    )
                  );
                }),
              )
            ),
            const SizedBox(height: 10,),
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
                  onTap: () => categoryProvider.logic.addNewTask(id),
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
                Buttons.dateButtons(buttonStartTime, Icons.access_time_outlined, item.color, () => categoryProvider.logic.pickStartTime(words, item.color), true),
                Buttons.dateButtons(buttonFinalTime, Icons.timelapse_outlined, item.color, () => categoryProvider.logic.pickEndTime(words, item.color), categoryProvider.startDate == DateTime(1889) ? false : true),
              ],
            )
          ],
        )
      )
    );
  }
}