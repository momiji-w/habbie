import 'package:flutter/material.dart';
import 'package:habbie/operations/habit.dart';
import 'package:habbie/schemes/habit.dart';

class CreateHabit {
  static Future<bool> show(BuildContext context) async {
    final GlobalKey<FormState> createForm = GlobalKey<FormState>();
    final TextEditingController editController = TextEditingController();

    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          title: const Text('Create'),
          content: Form(
            key: createForm,
            child: TextFormField(
              autofocus: true,
              validator: (value) {
                return value == null || value.isEmpty
                    ? "Title cannot be empty"
                    : null;
              },
              controller: editController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Title',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => editController.clear(),
                  )),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                editController.clear();
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (createForm.currentState!.validate()) {
                  await createHabit(Habit()..name = editController.text);
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
