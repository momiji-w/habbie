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
  void initState() async {
    super.initState();

    List<HabitHistory> value =
        await getHabitHistorysFromHabit(widget.habitDisplay.habit.id);

    setState(() {
      for (HabitHistory habitHistory in value) {
        habitHeatMap[DateTime.parse(habitHistory.date)] = habitHistory.habitId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HabbieTheme.primary,
        foregroundColor: HabbieTheme.onPrimary,
        title: Text(widget.habitDisplay.habit.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          Container(
            alignment: Alignment.center,
            child: HeatMapCalendar(
                datasets: habitHeatMap,
                monthFontSize: 17.0,
                weekTextColor: HabbieTheme.primary,
                textColor: HabbieTheme.onBackground,
                defaultColor: HabbieTheme.background,
                showColorTip: false,
                colorMode: ColorMode.color,
                colorsets: Map<int, Color>() = {1: HabbieTheme.primary}),
          ),
        ],
      ),
    );
  }
}
