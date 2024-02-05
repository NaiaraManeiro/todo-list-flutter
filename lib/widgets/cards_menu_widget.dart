import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardsMenu extends StatelessWidget {
  final Color iconColor;
  final VoidCallback onDeleteTasks;
  final VoidCallback onDeleteCategory;
  final VoidCallback onEdit;
  
  const CardsMenu({super.key, required this.onDeleteTasks, required this.onEdit, required this.iconColor, required this.onDeleteCategory});

  @override
  Widget build(BuildContext context) {
    AppLocalizations words = AppLocalizations.of(context)!;

    return PopupMenuButton(
      onSelected: (a) {
        switch (a) {
          case "edit":
            onEdit();
            break;
          case "deleteTasks":
            onDeleteTasks();
            break;
          case "deleteCategory":
            onDeleteCategory();
            break;
        }
      },
      itemBuilder: (ctx) {
        return [
          PopupMenuItem(
            value: "edit",
            child: ListTile(
              title: Text(words.editCategory),
              leading: Icon(
                Icons.edit,
                color: iconColor,
              ),
            ),
          ),
          PopupMenuItem(
            value: "deleteTasks",
            child: ListTile(
              title: Text(words.deleteTasks),
              leading: Icon(Icons.delete, color: iconColor),
            )
          ),
          PopupMenuItem(
            value: "deleteCategory",
            child: ListTile(
              title: Text(words.deleteCategory),
              leading: Icon(Icons.delete_forever_outlined, color: iconColor),
            )
          )
        ];
      },
      icon: Icon(
        Icons.more_vert_outlined,
        color: iconColor,
      ),
    );
  }
}