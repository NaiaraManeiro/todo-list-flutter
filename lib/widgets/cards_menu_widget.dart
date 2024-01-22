import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardsMenu extends StatelessWidget {
  final Color iconColor;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  
  const CardsMenu({super.key, required this.onDelete, required this.onEdit, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    AppLocalizations words = AppLocalizations.of(context)!;

    return PopupMenuButton(
      onSelected: (a) {
        switch (a) {
          case "edit":
            onEdit();
            break;
          case "delete":
            onDelete();
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
            value: "delete",
            child: ListTile(
              title: Text(words.deleteCategory),
              leading: Icon(Icons.delete, color: iconColor),
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