
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../pages.dart';

class InfoCategoryPage extends StatefulWidget {
  static String routeName = "infoCategory";

  const InfoCategoryPage({super.key});

  @override
  State<InfoCategoryPage> createState() => _InfoCategoryPageState();
}

class _InfoCategoryPageState extends State<InfoCategoryPage> {
  List<bool> isExpandedList = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context)..setContext(context);
    final mainProvider = Provider.of<MainPageProvider>(context)..setContext(context);

    final Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    mainProvider.selectedCategory = arguments?['item'];

    final taskProvider = Provider.of<TaskProvider>(context)..setContext(context, mainProvider.selectedCategory!.nameCategory);

    isExpandedList = isExpandedList.isEmpty 
      ? List.filled(taskProvider.tasks.length, false)
      : isExpandedList;
 
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
                icon: Icon(Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios, color: mainProvider.selectedCategory!.color,),
                onPressed: () {
                  if (!isLoading) {
                    taskProvider.tasks = [];
                    isExpandedList = []; 
                    Navigator.pushReplacementNamed(context, MainPage.routeName);
                  } 
                } 
              ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save_outlined, color: mainProvider.selectedCategory!.color),
            onPressed: () async{
              setState(() {
                isLoading = true;
              });
              await taskProvider.logic.updateProgress(mainProvider.selectedCategory!.nameCategory, mainProvider);
              setState(() {
                isLoading = false;
              });
            } 
          ),
          CardsMenu(iconColor: mainProvider.selectedCategory!.color, 
            onEdit: () async { mainProvider.logic.editCategories(mainProvider.selectedCategory!); }, 
            onDeleteTasks: () async { mainProvider.logic.deleteAllTasksCategory(mainProvider.selectedCategory!.nameCategory); }, 
            onDeleteCategory: () async { mainProvider.logic.deleteCategory(mainProvider.selectedCategory!.nameCategory, settingsProvider); }
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 30.0, bottom: 30.0),
            child: Column(
              children: [
                CategoryWidget.getCategoryWidget(context, mainProvider.selectedCategory!, false),
                const SizedBox(height: 30,),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: List.generate(taskProvider.tasks.length,
                      (index) { 
                        var currentTask = taskProvider.tasks.elementAt(index);
                        return Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  activeColor: mainProvider.selectedCategory!.color,
                                  value: taskProvider.tasks[index].progress == 100 ? true : false,
                                  onChanged: (value) {
                                    taskProvider.tasks[index].progress = value! ? 100 : 0;
                                    mainProvider.selectedCategory!.totalProgress = taskProvider.logic.totalProgress();
                                    taskProvider.refresh();
                                    mainProvider.refresh();
                                  },
                                ),
                                const SizedBox(width: 10),
                                Text(currentTask.name),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          isExpandedList[index] = !isExpandedList[index];
                                        });
                                      }, 
                                      icon: Icon(isExpandedList[index]  
                                        ? Icons.expand_less_outlined 
                                        : Icons.expand_more_outlined
                                      ), 
                                      label: const Text('')
                                    )
                                  )
                                )
                              ]       
                            ),
                            if (isExpandedList[index])
                              Row(
                                children: [
                                  Slider(
                                    activeColor: mainProvider.selectedCategory!.color,
                                    value: taskProvider.tasks[index].progress.toDouble(),
                                    min: 0,
                                    max: 100,
                                    onChangeEnd: (value) {
                                      taskProvider.tasks[index].progress = value.round();
                                      taskProvider.refresh();
                                      mainProvider.selectedCategory!.totalProgress = taskProvider.logic.totalProgress();
                                      mainProvider.refresh();
                                    }, 
                                    onChanged: (double value) {  },
                                  ), 
                                  Text("${taskProvider.tasks[index].progress} %")
                                ],
                              )
                          ]
                        );
                      },
                    ),
                  )
                ),
              ]
            )
          ),
          if (isLoading || taskProvider.tasks.isEmpty) const CircularProgressIndicator(color: Colors.black, strokeWidth: 3)
        ]
      ) 
    );
  }
}