import 'package:flutter/material.dart';
import 'package:habbie/operations/habit.dart';
import 'package:habbie/schemes/habit.dart';

class EditHabit {
  static Future<bool> show(BuildContext context, Habit habit) async {
    final GlobalKey<FormState> editForm = GlobalKey<FormState>();
    final TextEditingController titleController = TextEditingController();

    titleController.text = habit.name;

    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          title: const Text('Edit'),
          content: Form(
            key: editForm,
            child: TextFormField(
              autofocus: true,
              validator: (value) {
                return value == null || value.isEmpty
                    ? "Title cannot be empty"
                    : null;
              },
              controller: titleController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Title',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => titleController.clear(),
                  )),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                titleController.clear();
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (editForm.currentState!.validate()) {
                  habit.name = titleController.text;
                  await updateHabit(habit);
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
