import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habbie/operations/habit_history.dart';
import 'package:habbie/schemes/habit_display.dart';
import 'package:habbie/schemes/habit_history.dart';
import 'package:habbie/theme.dart';

class HabitDetail extends StatefulWidget {
  final HabitDisplay habitDisplay;
  const HabitDetail({super.key, required this.habitDisplay});

  @override
  State<HabitDetail> createState() => _HabitDetailState();
}

class _HabitDetailState extends State<HabitDetail> {
  Map<DateTime, int> habitHeatMap = {};

  @override
  void initState() {
    super.initState();

    getHabitHistorysFromHabit(widget.habitDisplay.habit.id).then((value) {
      setState(() {
        for (HabitHistory habitHistory in value) {
          habitHeatMap[DateTime.parse(habitHistory.date)] =
              habitHistory.habitId;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HabbieTheme.primary,
        foregroundColor: HabbieTheme.onPrimary,
        title: const Text("Detail"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${widget.habitDisplay.habit.name}',
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Description: ${widget.habitDisplay.habit.description}',
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'History:',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 20.0),
            HeatMapCalendar(
                datasets: habitHeatMap,
                monthFontSize: 17.0,
                weekTextColor: HabbieTheme.primary,
                textColor: HabbieTheme.onBackground,
                defaultColor: HabbieTheme.background,
                showColorTip: false,
                colorMode: ColorMode.color,
                colorsets: Map<int, Color>() = {1: HabbieTheme.primary}),
          ],
        ),
      ),
    );
  }
}
