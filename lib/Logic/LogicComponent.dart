import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduleyourday/Logic/boxes.dart';
import '../Model/Task.dart';

Map<String, Map<String, Map<String, dynamic>>>? toSent;
// final box = Boxes.getSchedules()
// List<List<Task>> listTasks = ;

class ListofTasksCubit extends Cubit<List<Task>> {
  ListofTasksCubit() : super([]);
  createTask(Task task) {
    String schedule = "0";
    String taskName = "0";
    emit(state);
  }

  addTaskToSchedule(Task taskSchedule, int scheduleNo) {
    int scheduleCount = state.length;
    if (scheduleNo == 0 && scheduleCount == 0) {
      print("condition1");
      emit([taskSchedule]);
    } else {
      print("condition2");

      List<Task> listTasks = state;
      listTasks.add(taskSchedule);
      // List<List<Task>> list = state;
      // list.insert(scheduleNo, listTasks);
      // state.addAll(taskSchedule);
      emit(listTasks);
    }
  }

  emitState() {
    emit(Boxes.getSchedules().values.toList());
  }
}

class RangeDurationCubit extends Cubit<List<DateTime?>> {
  RangeDurationCubit() : super([]);

  addDateTime(List<DateTime?> dateTime) {
    emit(dateTime);
  }

  replaceDateTime(
    List<DateTime?> dateTime,
  ) {
    state.removeRange(0, state.length);
    emit(dateTime);
  }

  empty() {
    emit([]);
  }

  emitState() {
    emit(state);
  }
}

class DailyDurationCubit extends Cubit<List<TimeOfDay?>> {
  DailyDurationCubit() : super([]);

  addTime(List<TimeOfDay?> dateTime) {
    emit(dateTime);
  }

  replaceTime(
    List<TimeOfDay?> dateTime,
  ) {
    state.removeRange(0, state.length);
    emit(dateTime);
  }

  empty() {
    emit([]);
  }
}

class DisplayDropDownCubit extends Cubit<String> {
  DisplayDropDownCubit() : super("Daily");

  changeValue(String value) {
    emit(value);
  }

  empty() {
    emit("Daily");
  }
}

class NotifificationChoiceCubit extends Cubit<int> {
  NotifificationChoiceCubit() : super(0);

  selectFrequency(int value) {
    emit(value);
  }

  empty() {
    emit(0);
  }
}

//to expand task
class ExpandItCubit extends Cubit<bool> {
  ExpandItCubit() : super(false);

  expandThetask() {
    emit(true);
  }

  contractTask() {
    emit(false);
  }
}

class ExpandTasksList extends Cubit<List> {
  ExpandTasksList() : super([]);

  emitState(List list) {
    emit(list);
  }

  // addToList(List<int> list, int index) {
  //   list.add(index);
  //   emit(list);
  // }

  // removeFromList(List<int> list, int index) {
  //   list.remove(index);
  //   emit(list);
  // }
}

class BottomSheetShownCubit extends Cubit<bool> {
  BottomSheetShownCubit() : super(false);

  closedSheet() {
    emit(false);
  }

  openSheet() {
    emit(true);
  }
}
