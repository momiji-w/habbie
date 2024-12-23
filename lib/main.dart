import 'package:flutter/material.dart';
import 'package:habbie/theme.dart';
import 'package:habbie/edit_dialog.dart';
import 'package:habbie/create_dialog.dart';
import 'package:habbie/tile.dart';
import 'package:habbie/schemes/habit_history.dart';
import 'package:habbie/schemes/habit_display.dart';
import 'package:habbie/operations/habit.dart';
import 'package:habbie/operations/habit_history.dart';
import 'package:habbie/utils/date_util.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData habbieTheme = ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: HabbieTheme.primary,
          onPrimary: HabbieTheme.onPrimary,
          surface: HabbieTheme.background,
          onSurface: HabbieTheme.onBackground,
        ));
    return MaterialApp(
        title: 'Habbie', theme: habbieTheme, home: const HabitTrackerPage());
  }
}

class HabitTrackerPage extends StatefulWidget {
  const HabitTrackerPage({super.key});

  @override
  State<HabitTrackerPage> createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
  List<HabitDisplay> habitDisplay = [];

  @override
  void initState() async {
    super.initState();

    List<HabitDisplay> value = await getHabitWithStatus();
    setState(() {
      habitDisplay = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HabbieTheme.primary,
        foregroundColor: HabbieTheme.onPrimary,
        title: const Text('Habits'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: habitDisplay.length,
              itemBuilder: (context, index) {
                return HabitTile(
                  habitDisplay: habitDisplay[index],
                  onToggleCompleted: (bool? value) async {
                    if (value == true) {
                      bool res = await createHabitHistory(HabitHistory()
                        ..habitId = habitDisplay[index].habit.id
                        ..date = getCurrentDate());

                      setState(() {
                        habitDisplay[index].completed = res;
                      });
                      return;
                    }

                    bool res = await deleteTodayHabitHistory(
                        habitDisplay[index].habit.id, getCurrentDate());

                    setState(() {
                      habitDisplay[index].completed = res;
                    });
                  },
                  onEdit: () async {
                    bool res = await EditHabit.show(
                        context, habitDisplay[index].habit);

                    if (res) {
                      List<HabitDisplay> value = await getHabitWithStatus();
                      setState(() {
                        habitDisplay = value;
                      });
                    }
                  },
                  onDelete: () async {
                    bool res = await deleteHabit(habitDisplay[index].habit.id);

                    if (res) {
                      setState(() {
                        habitDisplay.removeAt(index);
                      });
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool res = await CreateHabit.show(context);
          if (res) {
            List<HabitDisplay> value = await getHabitWithStatus();
            setState(() {
              habitDisplay = value;
            });
          }
        },
        backgroundColor: HabbieTheme.primary,
        foregroundColor: HabbieTheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
