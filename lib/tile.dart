import 'package:flutter/material.dart';
import 'package:habbie/detail_page.dart';
import 'package:habbie/schemes/habit_display.dart';
import 'package:habbie/theme.dart';

class HabitTile extends StatelessWidget {
  final HabitDisplay habitDisplay;
  final ValueChanged<bool?> onToggleCompleted;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HabitTile({
    super.key,
    required this.habitDisplay,
    required this.onToggleCompleted,
    required this.onEdit,
    required this.onDelete,
  });

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          title: const Text('Are you sure to delete'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: HabbieTheme.primary,
            width: 1.0,
          ),
        ),
        child: ListTile(
          title: Text(habitDisplay.habit.name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HabitDetail(habitDisplay: habitDisplay),
              ),
            );
          },
          leading: Checkbox(
            value: habitDisplay.completed,
            onChanged: onToggleCompleted,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final shouldDelete =
                      await _showDeleteConfirmationDialog(context);
                  if (shouldDelete) {
                    onDelete();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
