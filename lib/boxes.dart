import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Task.dart';

class Boxes {
  static Box<Task> getSchedules() => Hive.box<Task>("Schedules");
}
