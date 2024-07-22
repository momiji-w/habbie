import 'package:habbie/utils/date_util.dart';
import 'package:habbie/utils/isar_util.dart';
import 'package:isar/isar.dart';
import 'package:habbie/schemes/habit_history.dart';

Future<bool> createHabitHistory(HabitHistory habitHistory) async {
  final isar = await getIsar();

  int habitHistoryId = 0;

  await isar.writeTxn(() async {
    habitHistoryId = await isar.habitHistorys.put(habitHistory);
  });

  return habitHistoryId > 0;
}

Future<List<HabitHistory>> getHabitHistorys() async {
  final isar = await getIsar();
  List<HabitHistory> habitHistorys = [];

  habitHistorys = await isar.habitHistorys.where().findAll();

  return habitHistorys;
}

Future<List<HabitHistory>> getTodayHabitHistorys() async {
  final isar = await getIsar();
  List<HabitHistory> habitHistorys = [];

  habitHistorys =
      await isar.habitHistorys.filter().dateEqualTo(getCurrentDate()).findAll();

  return habitHistorys;
}

Future<List<HabitHistory>> getHabitHistorysFromHabit(int habitId) async {
  final isar = await getIsar();
  List<HabitHistory> habitHistorys = [];

  habitHistorys =
      await isar.habitHistorys.filter().habitIdEqualTo(habitId).findAll();

  return habitHistorys;
}

Future<HabitHistory?> getHabitHistory(int habitHistoryId) async {
  final isar = await getIsar();
  final habitHistory = await isar.habitHistorys.get(habitHistoryId);

  return habitHistory;
}

Future<bool> updateHabitHistory(HabitHistory habitHistory) async {
  final isar = await getIsar();

  HabitHistory? dbHabitHistory = await isar.habitHistorys.get(habitHistory.id);

  if (dbHabitHistory == null) {
    print("can't find habitHistory");
    return false;
  }

  dbHabitHistory.habitId = habitHistory.habitId;
  dbHabitHistory.date = habitHistory.date;

  int habitHistoryId = 0;

  await isar.writeTxn(() async {
    habitHistoryId = await isar.habitHistorys.put(dbHabitHistory);
  });

  return habitHistoryId > 0;
}

Future<bool> deleteTodayHabitHistory(int habitId, String date) async {
  final isar = await getIsar();
  List<HabitHistory> habitHistorys = await isar.habitHistorys
      .filter()
      .habitIdEqualTo(habitId)
      .dateEqualTo(date)
      .findAll();

  if (habitHistorys.isEmpty) {
    print("can't find habitHistory");
    return false;
  }

  List<int> ids = habitHistorys.map((e) => e.id).toList();

  await isar.writeTxn(() async {
    await isar.habitHistorys.deleteAll(ids);
  });

  return true;
}

Future<bool> deleteHabitHistory(int habitHistoryId) async {
  final isar = await getIsar();

  HabitHistory? dbHabitHistory = await isar.habitHistorys.get(habitHistoryId);

  if (dbHabitHistory == null) {
    print("can't find habitHistory");
    return false;
  }

  bool isSuccess = false;

  await isar.writeTxn(() async {
    isSuccess = await isar.habitHistorys.delete(dbHabitHistory.id);
  });

  return isSuccess;
}
