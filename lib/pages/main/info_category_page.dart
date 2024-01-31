
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
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final CardItem item = arguments?['item'];

    final mainProvider = Provider.of<MainPageProvider>(context)..setContext(context);
    final taskProvider = Provider.of<TaskProvider>(context)..setContext(context, item.nameCategory);

    List<bool> isExpandedList = List.filled(taskProvider.tasks.length, false);
 
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
                icon: Icon(Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios, color: item.color,),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, MainPage.routeName);
                } 
              ),
        actions: <Widget>[
          CardsMenu(iconColor: item.color, 
            onEdit: () async { mainProvider.logic.editCategories(item); }, 
            onDelete: () async { mainProvider.logic.deleteCategories(item.nameCategory, taskProvider); })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 30.0, bottom: 30.0),
        child: Column(
          children: [
            CategoryWidget.getCategoryWidget(context, item, false),
            const SizedBox(height: 30,),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: List.generate(taskProvider.tasks.length,
                  (index) { 
                    return Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              activeColor: item.color,
                              value: int.parse(taskProvider.tasks.elementAt(index).progress) * 100 == 100 ? true : false,
                              onChanged: (value) {
                                taskProvider.logic.updateProgress(taskProvider.tasks.elementAt(index).id, item.nameCategory, value! ? '100' : '0', mainProvider);
                              },
                            ),
                            const SizedBox(width: 10),
                            Text(taskProvider.tasks.elementAt(index).name),
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
                                activeColor: item.color,
                                value: double.parse(taskProvider.tasks.elementAt(index).progress),
                                min: 0,
                                max: 100,
                                onChanged: (value) {
                                  setState(() {
                                    taskProvider.logic.updateProgress(taskProvider.tasks.elementAt(index).id, item.nameCategory, value.round().toString(), mainProvider);
                                  });
                                },
                              ), 
                              Text("${int.parse(taskProvider.tasks.elementAt(index).progress)} %")
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