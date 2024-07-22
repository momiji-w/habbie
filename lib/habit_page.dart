import 'package:flutter/material.dart';
import 'package:habbie/about_page.dart';
import 'package:habbie/create_habit.dart';
import 'package:habbie/detail_page.dart';
import 'package:habbie/edit_habit.dart';
import 'package:habbie/schemes/habit_history.dart';
import 'package:habbie/theme.dart';
import 'package:habbie/schemes/habit_display.dart';
import 'package:habbie/operations/habit.dart';
import 'package:habbie/operations/habit_history.dart';
import 'package:habbie/utils/date_util.dart';

class HabitTrackerPage extends StatefulWidget {
  const HabitTrackerPage({super.key});

  @override
  State<HabitTrackerPage> createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
  List<HabitDisplay> habitDisplay = [];

  @override
  void initState() {
    super.initState();

    getHabitWithStatus().then((value) {
      setState(() {
        habitDisplay = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HabbieTheme.primary,
        foregroundColor: HabbieTheme.onPrimary,
        title: const Text('Habit Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutHabbie(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Your Habits',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: habitDisplay.length,
              itemBuilder: (context, index) {
                return HabitTile(
                  habitDisplay: habitDisplay[index],
                  onToggleCompleted: (bool? value) {
                    if (value == true) {
                      createHabitHistory(HabitHistory()
                            ..habitId = habitDisplay[index].habit.id
                            ..date = getCurrentDate())
                          .then((result) {
                        setState(() {
                          habitDisplay[index].completed = value ?? false;
                        });
                      });
                    } else {
                      deleteTodayHabitHistory(
                              habitDisplay[index].habit.id, getCurrentDate())
                          .then(
                        (result) {
                          setState(() {
                            habitDisplay[index].completed = value ?? false;
                          });
                        },
                      );
                    }
                  },
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditHabitPage(
                          habit: habitDisplay[index].habit,
                        ),
                      ),
                    ).then((value) {
                      getHabitWithStatus().then((value) {
                        setState(() {
                          habitDisplay = value;
                        });
                      });
                    });
                  },
                  onDelete: () {
                    deleteHabit(habitDisplay[index].habit.id).then((value) {
                      if (value) {
                        setState(() {
                          habitDisplay.removeAt(index);
                        });
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateHabitPage(),
            ),
          ).then((value) {
              getHabitWithStatus().then((value) {
                setState(() {
                  habitDisplay = value;
                });
              });
          });
          // Add new habit action
        },
        backgroundColor: HabbieTheme.primary,
        foregroundColor: HabbieTheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}

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
          borderRadius: BorderRadius.circular(10.0),
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
