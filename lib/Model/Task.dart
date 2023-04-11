import 'package:hive/hive.dart';
part 'Task.g.dart';

@HiveType(typeId: 0) //typdeId is unique for each model class
class Task extends HiveObject {
  @HiveField(0)
  String taskName = "";

  @HiveField(1)
  String type = ""; //1: daily , 2: datePicker

  @HiveField(2)
  List<String>? dailyTimeRange;

  @HiveField(3)
  List<DateTime>? dateTimeRange;

  @HiveField(4)
  String? description;

  @HiveField(5)
  String notifyChoice = ""; //1: notification every hour, 2: at completion

  @HiveField(6)
  int taskID = 0;

  @HiveField(7)
  List<bool>? isCompleted = [false];

  Task(this.taskID, this.taskName, this.type, this.notifyChoice, [this.description, this.dailyTimeRange, this.dateTimeRange, this.isCompleted]);
  Task.withDaily(this.taskID, this.taskName, this.type, this.notifyChoice, [this.description, this.dailyTimeRange]);
  Task.withRange(this.taskID, this.taskName, this.type, this.notifyChoice, [this.description, this.dateTimeRange]);

  // static Task fromJson(Map<String, Map<String, Map<String, dynamic>>> map) {
  //   Map<String, dynamic> taskMap = map;
  //   return Task(taskMap["taskName"], taskMap["type"], taskMap["notifyChoice"], taskMap["description"], taskMap["dateTimeRange"], taskMap["dailyTimeRange"]);
  // }

  static Map<String, dynamic> toJson(Task task) {
    Map<String, dynamic> map = {};
    // Map<String, Map<String, dynamic>> tasks = {taskName: map};
    // Map<String, Map<String, Map<String, dynamic>>> schedules = {schedule: tasks};
//
    map["taskName"] = task.taskName;
    map["type"] = task.type;
    map["notifyChoice"] = task.notifyChoice;
    map["description"] = task.description;
    map["dateTimeRange"] = task.dateTimeRange;
    map["dailyTimeRange"] = task.dailyTimeRange;
    map["taskID"] = task.taskID;
    return map;
  }

  // @override
  // List<Object> get props => [taskName, type, notifyChoice];
}
