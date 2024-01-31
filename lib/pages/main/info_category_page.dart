
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/models.dart';
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

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainPageProvider>(context)..setContext(context);

    final Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    mainProvider.selectedCategory = arguments?['item'];

    final taskProvider = Provider.of<TaskProvider>(context)..setContext(context, mainProvider.selectedCategory.nameCategory);

    isExpandedList = isExpandedList.isEmpty 
      ? List.filled(taskProvider.tasks.length, false)
      : isExpandedList;
 
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
                icon: Icon(Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios, color: mainProvider.selectedCategory.color,),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, MainPage.routeName);
                } 
              ),
        actions: <Widget>[
          CardsMenu(iconColor: mainProvider.selectedCategory.color, 
            onEdit: () async { mainProvider.logic.editCategories(mainProvider.selectedCategory); }, 
            onDelete: () async { mainProvider.logic.deleteCategories(mainProvider.selectedCategory.nameCategory); })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 30.0, bottom: 30.0),
        child: Column(
          children: [
            CategoryWidget.getCategoryWidget(context, mainProvider.selectedCategory, false),
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
                              activeColor: mainProvider.selectedCategory.color,
                              value: int.parse(currentTask.progress) == 100 ? true : false,
                              onChanged: (value) {
                                taskProvider.logic.updateProgress(currentTask.id, mainProvider.selectedCategory.nameCategory, value! ? '100' : '0', mainProvider);
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
                                activeColor: mainProvider.selectedCategory.color,
                                value: double.parse(currentTask.progress),
                                min: 0,
                                max: 100,
                                onChangeEnd: (value) {
                                  setState(() {
                                    taskProvider.logic.updateProgress(currentTask.id, mainProvider.selectedCategory.nameCategory, value.round().toString(), mainProvider);
                                  });
                                }, 
                                onChanged: (double value) {  },
                              ), 
                              Text("${int.parse(currentTask.progress)} %")
                            ],
                          )
                      ]
                    );
                  },
                ),
              )
            )
          ]
        )
      )
    );
  }
}