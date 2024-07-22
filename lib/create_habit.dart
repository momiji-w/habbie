import 'package:flutter/material.dart';
import 'package:habbie/operations/habit.dart';
import 'package:habbie/schemes/habit.dart';
import 'package:habbie/theme.dart';

class CreateHabitPage extends StatefulWidget {
  const CreateHabitPage({super.key});

  @override
  State<CreateHabitPage> createState() => _CreateHabitPageState();
}

class _CreateHabitPageState extends State<CreateHabitPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HabbieTheme.primary,
        foregroundColor: HabbieTheme.onPrimary,
        title: const Text('Create'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Title',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _titleController.clear(),
                  )),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Description',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _descriptionController.clear(),
                  )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createHabit(Habit()
                ..name = _titleController.text
                ..description = _descriptionController.text)
              .then((value) {
            if (value) {
              Navigator.pop(context);
            }
          });
        },
        backgroundColor: HabbieTheme.primary,
        foregroundColor: HabbieTheme.onPrimary,
        child: const Icon(Icons.check),
      ),
    );
  }
}
