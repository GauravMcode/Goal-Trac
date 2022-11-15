import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scheduleyourday/Screens/HomePage.dart';
import 'package:scheduleyourday/Model/Task.dart';
import 'package:scheduleyourday/Screens/Logic/boxes.dart';
import 'custompaints.dart';
import 'CreateTask.dart';
import '../Screens/Logic/LogicComponent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

class MySchedule extends StatefulWidget {
  int scheduleNo;

  MySchedule(this.scheduleNo);

  @override
  State<MySchedule> createState() => _MyScheduleState(scheduleNo);
}

class _MyScheduleState extends State<MySchedule> {
  int scheduleNo;
  _MyScheduleState(this.scheduleNo);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double widthLocal = MediaQuery.of(context).size.width;
    double heightLocal = MediaQuery.of(context).size.height;
    double width = math.min(widthLocal, heightLocal);
    double height = math.max(widthLocal, heightLocal);

    return BlocBuilder<ListofTasksCubit, List<Task>>(
      buildWhen: (previous, current) {
        return current != previous && current != {};
      },
      builder: (context, state) {
        return BlocBuilder<ExpandTasksList, List>(
          buildWhen: (previous, current) => previous.length != current.length,
          builder: (context, lState) {
            print("building it...........");
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: width * 0.03,
                      ),
                      alignment: Alignment.center,
                      width: width * 0.5,
                      height: height * 0.07,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        gradient: LinearGradient(colors: colors1),
                      ),
                      child: MaterialButton(
                        autofocus: true,
                        focusElevation: 100.0,
                        splashColor: Colors.amber,
                        elevation: 100.0,
                        minWidth: width * 0.6,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                        onPressed: () {
                          createTask(scheduleNo, context, height, width, _formKey);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: width * 0.05),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                textAlign: TextAlign.left,
                                "Add a New Task",
                                style: GoogleFonts.pacifico(color: Colors.black, fontSize: 15),
                              ),
                              Icon(
                                Icons.add_circle,
                                size: height * 0.05,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: CustomPaint(
                        painter: LogoCustomPainter1(true),
                        child: Container(
                          alignment: Alignment.center,
                          width: width * 0.20,
                          height: height * 0.08,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Schedule\nPlanner",
                                style: GoogleFonts.pacifico(color: colors[2], fontStyle: FontStyle.italic, fontSize: 10),
                              ),
                              SizedBox(
                                width: width * 0.1,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.01),

                BlocBuilder<ExpandItCubit, bool>(
                  builder: (context, isExpandedState) {
                    return BlocBuilder<ExpandTasksList, List>(
                      builder: (context, expandTaskState) {
                        print("building it...........");
                        return ValueListenableBuilder<Box<Task>>(
                          valueListenable: Boxes.getSchedules().listenable(),
                          builder: ((context, box, child) {
                            print("123455");
                            // List<Task> listOfTasks = [];
                            // box.values.where((element) => element.taskID==0);
                            final ids = Set();
                            List ListHere = box.keys.toList();
                            List uniqueItems = [];
                            for (var i = 1; i < ListHere.length; i++) {
                              if (ListHere[i] != ListHere[i - 1]) {
                                uniqueItems.add(ListHere[i]);
                              }
                            }
                            print(box.keys.length);

                            if (box.values.length != 0) {
                              // final listOfTasks = box.getAt(0)!. .toList().cast<Task>();
                              // print(box.values.where((element) => element.taskID == scheduleNo));
                            }

                            Map<dynamic, Task> mapAll = box.toMap();
                            Map<dynamic, Task> mapSchedlueNo = {};
                            mapAll.values.forEach((element) {
                              if (element.taskID == scheduleNo) {
                                mapSchedlueNo.addAll({element.key: element});
                              }
                            });
                            List<Task> tasksList = mapSchedlueNo.values.toList();
                            final keysList = mapSchedlueNo.keys.toList();
                            // print("task id: ${tasksList[0].taskID}");
                            print(keysList);
                            print(mapAll);
                            print(mapSchedlueNo);
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: height * 0.68,
                                  width: width,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: List.generate(tasksList.length, (index) {
                                      Task task = tasksList[index];
                                      String displayDate1 = task.dateTimeRange != null ? "${task.dateTimeRange![0].day}/${task.dateTimeRange![0].month}/${task.dateTimeRange![0].year}" : "";
                                      String displayDate2 = task.dateTimeRange != null ? "${task.dateTimeRange![1].day}/${task.dateTimeRange![1].month}/${task.dateTimeRange![1].year}" : "";
                                      return Card(
                                        color: Colors.black54,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                        elevation: 20.0,
                                        child: Container(
                                            margin: const EdgeInsets.all(7.0),
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: colors1),
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("Task ${(index + 1).toString()}"),
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                            onPressed: (() {
                                                              editTask(scheduleNo, task, keysList[index], context, height, width, _formKey);
                                                            }),
                                                            icon: Icon(Icons.edit)),
                                                        IconButton(
                                                          onPressed: (() {
                                                            box.delete(keysList[index]);
                                                          }),
                                                          icon: Icon(Icons.delete),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(task.taskName, style: const TextStyle(fontSize: 20)),
                                                    !(context.read<ExpandItCubit>().state && context.read<ExpandTasksList>().state.contains(index))
                                                        ? IconButton(
                                                            onPressed: () {
                                                              if (!context.read<ExpandTasksList>().state.contains(index)) {
                                                                List list = expandTaskState;
                                                                list.add(index);
                                                                context.read<ExpandTasksList>().emitState(list);
                                                                setState(() {});
                                                              }
                                                              context.read<ExpandItCubit>().expandThetask();
                                                              print(context.read<ExpandTasksList>().state);
                                                            },
                                                            icon: const Icon(Icons.arrow_drop_down_circle_outlined))
                                                        : IconButton(
                                                            onPressed: () {
                                                              // context.read<ExpandItCubit>().contractTask();
                                                              List list = expandTaskState;
                                                              list.remove(index);
                                                              context.read<ExpandTasksList>().emitState(list);
                                                              setState(() {});
                                                              print(context.read<ExpandTasksList>().state);
                                                            },
                                                            icon: const Icon(Icons.arrow_drop_up_outlined)),
                                                  ],
                                                ),
                                                context.read<ExpandTasksList>().state.contains(index)
                                                    ? Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              SizedBox(width: width * 0.02),
                                                            ],
                                                          ),
                                                          Text(task.description.toString()),
                                                          Text("Type of Task: ${task.type == "1" ? "Daily" : "Range of Dates"}"),
                                                          task.dailyTimeRange != null ? Text(task.dailyTimeRange!.toString()) : Text("$displayDate1-$displayDate2"),
                                                        ],
                                                      )
                                                    : Container(),
                                              ],
                                            )),
                                      );
                                    }),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Error"),
                                            content: Text("Do you want to delete All Schedules?"),
                                            actions: <Widget>[
                                              MaterialButton(
                                                child: Text("Confirm"),
                                                onPressed: () {
                                                  box.clear();
                                                },
                                              ),
                                              MaterialButton(
                                                child: Text("cancel"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Text("Clear All Schedules"),
                                  color: Colors.amber,
                                )
                              ],
                            );
                          }),
                        );
                      },
                    );
                  },
                ),
                // Container(
                //   height: height * 0.5,
                //   width: width * 0.8,
                //   child: ListView(
                //     children: [
                //       Text(context.read<ListofTasksCubit>().state.toString()),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: height * 0.1,
                //   width: width,
                //   child: ListView.builder(
                //       itemCount: context.read<ListofTasksCubit>().state.length == 0 ? 0 : context.read<ListofTasksCubit>().state["0"]!.length,
                //       itemBuilder: ((context, index) {
                //         return ListTile(
                //           title: Text(context.read<ListofTasksCubit>().state["0"]![""]!["taskName"]),
                //           subtitle: Text(context.read<ListofTasksCubit>().state["0"]![""]!["description"]),
                //         );
                //       })),
                // )
              ],
            );
          },
        );
      },
    );
  }
}

Widget taskForm(BuildContext context, Key key) {
  return Form(
    key: key,
    child: Column(
      children: <Widget>[TextFormField()],
    ),
  );
}

// Column(
//                   children: [
//                     box.values.length != 0
//                         ? Container(
//                             height: height * 0.5,
//                             width: width * 0.8,
//                             child: ListView(
//                               children: [
//                                 Text("values:"),
//                                 Text([
//                                   Task.toJson(box.getAt(0)!),
//                                   // Task.toJson(box.getAt(1)!),
//                                   // Task.toJson(box.getAt(2)!),
//                                 ].toString()),
//                                 // Text(listOfTasks.toString()),
//                                 Text("keys"),
//                                 Text(box.values.length.toString()),
//                                 Text("task 0:  ${box.toMap()}"),
//                                 Text("Element at taskID==0 ${Task.toJson(box.values.where((element) => element.taskID > 0).first)}")
//                               ],
//                             ),
//                           )
//                         : Container(),
//                     Container(
//                         // child: Text(context.read<ListofTasksCubit>().state.toString()),
//                         ),
//                     MaterialButton(
//                       onPressed: (() {
//                         box.clear();
//                         // context.read<ListofTasksCubit>().emitState();
//                       }),
//                       child: Text("Clear All"),
//                     ),
//                   ],
//                 );

editTask(int scheduleNo, Task task, index, BuildContext context, double height, double width, GlobalKey<FormState> formKey) {
  Task taskToEdit = task;
  String nameInit = taskToEdit.taskName;
  String? descInit = taskToEdit.description;
  String displayDate = "Pick a Date";
  int? durationHours;
  int? durationDays;
  int? durationMinutes;

  context.read<NotifificationChoiceCubit>().selectFrequency(taskToEdit.notifyChoice == "1" ? 1 : 2);
  if (taskToEdit.dateTimeRange != null) {
    print("Date Time Range");
    context.read<RangeDurationCubit>().addDateTime(taskToEdit.dateTimeRange!);

    String displayDate1 = "${context.read<RangeDurationCubit>().state[0]?.day}/${context.read<RangeDurationCubit>().state[0]?.month}/${context.read<RangeDurationCubit>().state[0]?.year}";
    String displayDate2 = "${context.read<RangeDurationCubit>().state[1]?.day}/${context.read<RangeDurationCubit>().state[1]?.month}/${context.read<RangeDurationCubit>().state[1]?.year}";
    int? durationDays = context.read<RangeDurationCubit>().state[1]?.difference(context.read<RangeDurationCubit>().state[0]!).inDays;
    displayDate = durationDays == 0 ? "Date: $displayDate1" : "$displayDate1-$displayDate2";
    durationHours = context.read<RangeDurationCubit>().state[1]?.difference(context.read<RangeDurationCubit>().state[0]!).inHours;
    durationMinutes = context.read<RangeDurationCubit>().state[1]?.difference(context.read<RangeDurationCubit>().state[0]!).inMinutes;
    durationDays = context.read<RangeDurationCubit>().state[1]?.difference(context.read<RangeDurationCubit>().state[0]!).inDays;
    context.read<DisplayDropDownCubit>().changeValue(displayDate);
    createTask(scheduleNo, context, height, width, formKey,
        nameInit: nameInit, descrInit: descInit, index: index, editMode: true, displayitem: displayDate, hours: durationHours, days: durationDays, minutes: durationMinutes);
  } else {
    print("Daily");
    int L1 = taskToEdit.dailyTimeRange![0].length;
    int L2 = taskToEdit.dailyTimeRange![1].length;
    final time1;
    final time2;

    time1 = taskToEdit.dailyTimeRange![0].substring(0, 5).trimRight().split(":");
    time2 = taskToEdit.dailyTimeRange![1].substring(0, 5).trimRight().split(":");
    List<List<int>> timeList = [
      [int.parse(time1[0]), int.parse(time1[1])],
      [int.parse(time2[0]), int.parse(time2[1])]
    ];
    //connverting AM-PM to 24 hr format
    timeList[0][0] = taskToEdit.dailyTimeRange![0].substring(L1 - 2) == "AM" && timeList[0][0] == 12 ? 0 : timeList[0][0];
    timeList[1][0] = taskToEdit.dailyTimeRange![1].substring(L2 - 2) == "AM" && timeList[1][0] == 12 ? 0 : timeList[1][0];

    timeList[0][0] = taskToEdit.dailyTimeRange![0].substring(L1 - 2) == "PM" ? timeList[0][0] + 12 : timeList[0][0];
    timeList[1][0] = taskToEdit.dailyTimeRange![1].substring(L2 - 2) == "PM" ? timeList[1][0] + 12 : timeList[1][0];

    // context.read<DisplayDropDownCubit>().changeValue(displayDate);
    context.read<DailyDurationCubit>().addTime([TimeOfDay(hour: timeList[0][0], minute: timeList[0][1]), TimeOfDay(hour: timeList[1][0], minute: timeList[1][1])]);
    durationDays = 0;
    durationHours = context.read<DailyDurationCubit>().state[1]!.hour - context.read<DailyDurationCubit>().state[0]!.hour;
    durationMinutes = durationHours != 0 ? (context.read<DailyDurationCubit>().state[1]!.minute) % (durationHours * 60) : context.read<DailyDurationCubit>().state[1]!.minute;
    createTask(scheduleNo, context, height, width, formKey,
        nameInit: nameInit, descrInit: descInit, index: index, editMode: true, displayitem: displayDate, hours: durationHours, days: durationDays, minutes: durationMinutes);
  }
}
