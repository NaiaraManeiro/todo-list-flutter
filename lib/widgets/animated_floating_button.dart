import 'package:circle_list/circle_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/models.dart';
import '../pages/pages.dart';
import '../providers/providers.dart';

class CircleListFloatingButton extends StatefulWidget {
  const CircleListFloatingButton({super.key});

  @override
  _CircleListFloatingButtonState createState() =>
      _CircleListFloatingButtonState();
}

class _CircleListFloatingButtonState extends State<CircleListFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showCircleList = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainPageProvider>(context)..setContext(context);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _showCircleList = false;
          _controller.reverse();
        });
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (!_showCircleList)
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showCircleList = true;
                  _controller.forward();
                });
              },
              child: AnimatedIcon(
                icon: AnimatedIcons.add_event,
                progress: _controller,
              ),
            ),
          if (_showCircleList)
            Positioned(
              bottom: -150,
              child: CircleList(
                origin: const Offset(0, 0),
                children: List.generate(mainProvider.categories!.length, (index) {
                  return _buildOptionButton(mainProvider.categories!.elementAt(index), index);
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(CardItem item, int index) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: item.color,
      ),
      child: IconButton(
        icon: Icon(item.icon, size: 40.0),
        onPressed: () {
          setState(() {
            _showCircleList = false;
            _controller.reverse();
          });
          Navigator.pushReplacementNamed(context, NewTaskPage.routeName, 
            arguments: {
              'item': item
            }
          );
        },
        color: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}