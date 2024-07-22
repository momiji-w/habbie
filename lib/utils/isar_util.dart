import 'package:habbie/schemes/habit.dart';
import 'package:habbie/schemes/habit_history.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

Future<Isar> getIsar() async {
  final findIsar = Isar.getInstance();

  if (findIsar != null) {
    return findIsar;
  } 

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([HabitSchema, HabitHistorySchema], directory: dir.path);
  return isar;
}
