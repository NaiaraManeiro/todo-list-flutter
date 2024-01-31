
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/models.dart';
import '../providers/providers.dart';
import 'widgets.dart';

class CategoryWidget {

  static Widget getCategoryWidget(BuildContext context, CardItem item, bool show) {
    final mainProvider = Provider.of<MainPageProvider>(context)..setContext(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            if (show)
              CardsMenu(iconColor: item.color, 
                onEdit: () async { mainProvider.logic.editCategories(item); }, 
                onDelete: () async { mainProvider.logic.deleteCategories(item.nameCategory); })
          ]
        ),
        const SizedBox(height: 50,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.nameCategory, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            Row(
              children: [
                Icon(Icons.timer_outlined, color: item.color,),
                Text(item.totalTime, style: TextStyle(color: item.color),),
              ],
            )      
          ]
        ),
        Text(item.totalTareas),
        Text(
          '${item.totalProgress.toDouble().toStringAsFixed(0)}%',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 10,),
        SizedBox(
          height: 10,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              value: item.totalProgress.toDouble()/100,
              color: item.color,
              backgroundColor: const Color.fromARGB(255, 201, 201, 201),
              semanticsLabel: 'Linear progress indicator',
            ),
          )
        )
      ]
    );
  }
}