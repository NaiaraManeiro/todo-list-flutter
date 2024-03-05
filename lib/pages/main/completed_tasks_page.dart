
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../model/models.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../pages.dart';

class CompletedTasksPage extends StatefulWidget {
  static String routeName = "completedTasks";

  const CompletedTasksPage({super.key});

  @override
  State<CompletedTasksPage> createState() => __CompletedTasksState();
}

class __CompletedTasksState extends State<CompletedTasksPage> {
  List<bool> isExpandedList = [];

  @override
  Widget build(BuildContext context) {
    AppLocalizations words = AppLocalizations.of(context)!;
    final completedTasksProvider = Provider.of<CompletedTasksProvider>(context)..setContext(context);

    isExpandedList = isExpandedList.isEmpty 
      ? completedTasksProvider.copyList == null ? [] : List.filled(completedTasksProvider.copyList!.length, false)
      : isExpandedList;

    return Scaffold(
      appBar: AppBar(
        title: Text(words.tasksDoneTitle),
        leading: IconButton(
          icon: Icon(Platform.isAndroid
            ? Icons.arrow_back
            : Icons.arrow_back_ios, color: Colors.black,),
          onPressed: () => {
            completedTasksProvider.logic.limpiarFiltro(),
            Navigator.pushReplacementNamed(context, MainPage.routeName),
          } 
        ),
        actions: [
          Builder(
            builder: (BuildContext builderContext) {
              return  IconButton(
                icon: const Icon(Icons.filter_alt_outlined),
                onPressed: () {
                  Scaffold.of(builderContext).openEndDrawer();
                },
              );
            }
          )
        ],
      ),
      endDrawer: CustomFilter.getDrawerFilter(context, completedTasksProvider),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: completedTasksProvider.doneTasks == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(words.noDoneTasks),
                    const SizedBox(height: 80,),
                    const Icon(Icons.event_busy_outlined, size: 100,)
                  ]
                )
              )
          : Column(
              children: [ 
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: List.generate(completedTasksProvider.doneTasks!.length,
                      (index) { 
                        CardItem item = completedTasksProvider.doneTasks!.elementAt(index);
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: item.color, width: 2.0,),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(item.icon, color: item.color,),
                                      ),
                                    ),
                                    const SizedBox(width: 15,),
                                    Text(item.nameCategory, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(item.tasks.length == 1
                                      ? words.numDoneTask(item.tasks.length)
                                      : words.numDoneTasks(item.tasks.length)
                                    ),
                                    TextButton.icon(
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
                                  ]       
                                ),
                                if (isExpandedList[index])
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,  
                                        width: 1.0,            
                                      ),
                                     borderRadius: BorderRadius.circular(10.0), 
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: List.generate(item.tasks.length,
                                        (index) { 
                                          TaskModel task = item.tasks.elementAt(index);
                                          return Container(
                                            margin: const EdgeInsets.only(bottom: 10),
                                            child : Row(
                                              children: [
                                                Icon(Icons.radio_button_checked_outlined, color: item.color),
                                                const SizedBox(width: 10,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(task.name, style: const TextStyle(fontWeight: FontWeight.bold),),
                                                    Text("${task.dateIni} / ${task.dateFin}", style: const TextStyle(fontWeight: FontWeight.w300))
                                                  ],
                                                ),
                                              ]
                                            )
                                          );
                                        }
                                      )
                                    )
                                  )
                              ],
                            ),
                          )
                        );
                      }
                    )
                  )
                )
              ]
            )      
      )
    );
  }
}