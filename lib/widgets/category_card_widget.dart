
import 'package:flutter/material.dart';

class CardItem {
  late IconData icon;
  late MaterialColor color;
  late String nameCategory;
  late String totalTareas;
  late String totalProgress;
  late String totalTime;
  CardItem(this.icon, this.color, this.nameCategory, this.totalTareas, this.totalProgress, this.totalTime);
}

class CategoryCard {

  static Widget getCategoryCard(BuildContext context, CardItem item) {
    return GestureDetector (
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
          child: Column(
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
                  IconButton(
                    icon: Icon(Icons.more_vert_outlined, color: item.color),
                    onPressed: () {
                        
                    },
                  )
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
                '${(double.parse(item.totalProgress) * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 10,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    value: double.parse(item.totalProgress),
                    color: item.color,
                    backgroundColor: const Color.fromARGB(255, 201, 201, 201),
                    semanticsLabel: 'Linear progress indicator',
                  ),
                )
              )
            ]
          ),
        )
      ),
      onTap: () {

      }
    );
  }
}