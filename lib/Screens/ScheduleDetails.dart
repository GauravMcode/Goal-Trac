import 'package:flutter/material.dart';
import 'package:scheduleyourday/Screens/HomePage.dart';
import 'package:scheduleyourday/view_Methods/custompaints.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scheduleyourday/Model/Task.dart';
import 'package:scheduleyourday/Logic/boxes.dart';
import '../Logic/LogicComponent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class ScheduleDetails extends StatefulWidget {
  int scheduleNo;
  int scheduleIndex;
  ScheduleDetails(this.scheduleNo, this.scheduleIndex);

  @override
  State<ScheduleDetails> createState() => _ScheduleDetailsState(scheduleNo, scheduleIndex);
}

class _ScheduleDetailsState extends State<ScheduleDetails> {
  int scheduleNo;
  int scheduleIndex;
  _ScheduleDetailsState(this.scheduleNo, this.scheduleIndex);
  @override
  Widget build(BuildContext context) {
    double widthLocal = MediaQuery.of(context).size.width;
    double heightLocal = MediaQuery.of(context).size.height;
    double width = math.min(widthLocal, heightLocal);
    double height = math.max(widthLocal, heightLocal);
    return Scaffold(
      appBar: NewGradientAppBar(
        gradient: LinearGradient(colors: colors2),
        leading: IconButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            icon: Icon(Icons.arrow_back)),
        title: Text("Schedule $scheduleIndex"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(gradient: LinearGradient(colors: colors.sublist(0, 2))),
            child: BlocBuilder<ExpandItCubit, bool>(
              builder: (context, isExpandedState) {
                return BlocBuilder<ExpandTasksList, List>(
                  builder: (context, expandTaskState) {
                    return Column(
                      children: [
                        SizedBox(height: height * 0.4),
                        ValueListenableBuilder<Box<Task>>(
                          valueListenable: Boxes.getSchedules().listenable(),
                          builder: ((context, box, child) {
                            final ids = Set();
                            List ListHere = box.keys.toList();
                            List uniqueItems = [];
                            for (var i = 1; i < ListHere.length; i++) {
                              if (ListHere[i] != ListHere[i - 1]) {
                                uniqueItems.add(ListHere[i]);
                              }
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
                            return Container(
                              height: height * 0.5,
                              // width: width * 0.8,
                              child: ListView.builder(
                                itemCount: tasksList.length,
                                itemBuilder: ((context, index) {
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
                            );
                          }),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
