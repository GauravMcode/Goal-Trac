import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../Model/Task.dart';

class Boxes {
  static Box<Task> getSchedules() => Hive.box<Task>("Schedules");
}
