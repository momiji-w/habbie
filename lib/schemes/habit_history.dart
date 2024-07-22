import 'package:isar/isar.dart';

part 'habit_history.g.dart';

@collection
class HabitHistory {
    Id id = Isar.autoIncrement;
    late String date;
    late int habitId;
}
