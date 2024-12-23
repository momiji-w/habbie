import 'package:habbie/operations/habit_history.dart';
import 'package:habbie/schemes/habit_display.dart';
import 'package:habbie/schemes/habit_history.dart';
import 'package:habbie/utils/isar_util.dart';
import 'package:isar/isar.dart';
import 'package:habbie/schemes/habit.dart';

Future<bool> createHabit(Habit habit) async {
  final isar = await getIsar();

  int habitId = 0;

  await isar.writeTxn(() async {
    habitId = await isar.habits.put(habit);
  });

  return habitId > 0;
}

Future<List<Habit>> getHabits() async {
  final isar = await getIsar();
  List<Habit> habits = [];

  habits = await isar.habits.where().findAll();

  return habits;
}

Future<List<HabitDisplay>> getHabitWithStatus() async {
  final isar = await getIsar();
  List<HabitDisplay> habitDisplays = [];
  List<Habit> habits = [];

  habits = await isar.habits.where().findAll();
  List<HabitHistory> todayHabitHistorys = await getTodayHabitHistorys();

  for (Habit habit in habits) {
    habitDisplays.add(HabitDisplay(
        habit: habit,
        completed:
            todayHabitHistorys.any((element) => element.habitId == habit.id)));
  }

  return habitDisplays;
}

Future<Habit?> getHabit(int habitId) async {
  final isar = await getIsar();
  final habit = await isar.habits.get(habitId);

  return habit;
}

Future<bool> updateHabit(Habit habit) async {
  final isar = await getIsar();

  Habit? dbHabit = await isar.habits.get(habit.id);

  if (dbHabit == null) {
    return false;
  }

  dbHabit.name = habit.name;

  int habitId = 0;

  await isar.writeTxn(() async {
    habitId = await isar.habits.put(dbHabit);
  });

  return habitId > 0;
}

Future<bool> deleteHabit(int habitId) async {
  final isar = await getIsar();

  Habit? dbHabit = await isar.habits.get(habitId);

  if (dbHabit == null) {
    // print("can't find habit");
    return false;
  }

  bool isSuccess = false;

  await isar.writeTxn(() async {
    isSuccess = await isar.habits.delete(dbHabit.id);
  });

  return isSuccess;
}
