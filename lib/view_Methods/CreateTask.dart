import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:scheduleyourday/Model/Task.dart';
import 'package:scheduleyourday/Logic/boxes.dart';
import '../Logic/LogicComponent.dart';
import 'package:scheduleyourday/view_Methods/DateTimePicker/omni_datetime_picker.dart';
import 'package:scheduleyourday/Screens/HomePage.dart';

createTask(int scheduleNo, BuildContext context, double height, double width, formKey,
    {String nameInit = "", String? descrInit = "", bool editMode = false, int index = 0, displayitem = "", int? hours, int? days, int? minutes}) {
  print(context.read<DailyDurationCubit>().state);
  TextEditingController taskName = TextEditingController(text: nameInit);
  TextEditingController taskDescription = TextEditingController(text: descrInit);
  String name = nameInit;
  String? description = descrInit;
  List<Color> buttonColors = [Colors.transparent, Colors.yellow.shade400];
  double fontSize = 15.0;
  String zero = "0";
  String empty = "";
  String dropDownItem1 = "Daily";
  String dropDownItem2 = editMode ? displayitem : "Pick a Date";
  int? durationDays = editMode ? days : null;
  int? durationHours = editMode ? hours : null;
  int? durationMinutes = editMode ? minutes : null;
  DateTime? omniStart;
  DateTime? omniEnd;
  String displayDate1 = "";
  String displayDate2 = "";
  String displayDate = "";
  TimeOfDay? dailyTime1 = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay? dailyTime2 = const TimeOfDay(hour: 0, minute: 0);

  saveTask() {
    final box = Boxes.getSchedules();
    List<DateTime> dateTimeList = context.read<RangeDurationCubit>().state.isNotEmpty ? [context.read<RangeDurationCubit>().state[0]!, context.read<RangeDurationCubit>().state[1]!] : [];
    List<String> timeList =
        context.read<DailyDurationCubit>().state.isNotEmpty ? [context.read<DailyDurationCubit>().state[0]!.format(context), context.read<DailyDurationCubit>().state[1]!.format(context)] : [];

    int numberOfTasks = box.keys.length;

    String type = context.read<DisplayDropDownCubit>().state == "Daily" ? "1" : "2";

    Task task = type == "2"
        ? Task.withRange(scheduleNo, name, type, context.read<NotifificationChoiceCubit>().state.toString(), description, dateTimeList)
        : Task.withDaily(scheduleNo, name, type, context.read<NotifificationChoiceCubit>().state.toString(), description, timeList);

    // if (numberOfTasks == 0) {
    //   box.put(("0"), [task]);
    // } else {

    // }

    context.read<ListofTasksCubit>().addTaskToSchedule(task, 0);
    // List<Task> list = context.read<ListofTasksCubit>().state;
    // box.put("0", task);
    List<Task> listT = box.values.where((element) => element.taskID == scheduleNo).toList();
    Map<dynamic, Task> mapT = box.toMap();
    for (var element in listT) {
      mapT["$scheduleNo"] = element;
    }
    mapT.addAll({"$scheduleNo+1": task});

    editMode //todo: work for the edit mode
        ? box.put(index, task)
        : numberOfTasks == 0
            ? box.add(task)
            : box.add(task);

    editMode ? print("task edited saved at index $index with schedule No $scheduleNo") : print("Task Saved");
    Navigator.pop(context);
  }

  showAnimatedDialog(
      barrierDismissible: false,
      animationType: !editMode ? DialogTransitionType.slideFromLeftFade : DialogTransitionType.slideFromRightFade,
      curve: Curves.decelerate,
      duration: const Duration(milliseconds: 650),
      context: context,
      builder: (context) {
        double borderRadius = 40.0;
        final box = Boxes.getSchedules();
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          title: Center(
              child: editMode
                  ? const Text("")
                  : Text(
                      "Task ${box.values.length + 1}",
                      style: const TextStyle(color: Colors.white),
                    )),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          elevation: 10.0,
          backgroundColor: colors[1].withOpacity(0.1),
          contentPadding: EdgeInsets.zero,
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: (() {
                    Navigator.of(context).pop();

                    context.read<RangeDurationCubit>().empty();
                    context.read<DailyDurationCubit>().empty();
                    context.read<DisplayDropDownCubit>().empty();
                    context.read<NotifificationChoiceCubit>().empty();
                  }),
                  style: ButtonStyle(shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius))))),
                  child: Text("Back"),
                )),
                Expanded(
                    child: ElevatedButton(
                  onPressed: (() {
                    if ((context.read<DailyDurationCubit>().state.contains(null) || context.read<RangeDurationCubit>().state.contains(null))) {
                      showError("Select both the ranges. One cannot be null", context);
                    }
                    if (context.read<DailyDurationCubit>().state.isEmpty && context.read<RangeDurationCubit>().state.isEmpty) {
                      showError("First select a Range", context);
                    }
                    if ((!context.read<DailyDurationCubit>().state.contains(null) && !context.read<RangeDurationCubit>().state.contains(null)) &&
                        (context.read<DailyDurationCubit>().state.isNotEmpty || context.read<RangeDurationCubit>().state.isNotEmpty)) {
                      saveTask();
                    }
                    context.read<RangeDurationCubit>().empty();
                    context.read<DailyDurationCubit>().empty();
                    context.read<DisplayDropDownCubit>().empty();
                    context.read<NotifificationChoiceCubit>().empty();
                  }),
                  style: ButtonStyle(shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius))))),
                  child: Text("Save"),
                )),
              ],
            )
          ],
          content: BlocBuilder<RangeDurationCubit, List<DateTime?>>(
            builder: (context, durationState) {
              return BlocBuilder<DisplayDropDownCubit, String>(
                builder: (context, displayState) {
                  return BlocBuilder<DailyDurationCubit, List<TimeOfDay?>>(
                    builder: (context, dailyState) {
                      return BlocBuilder<NotifificationChoiceCubit, int>(
                        builder: (context, state) {
                          return WillPopScope(
                            onWillPop: () async {
                              context.read<RangeDurationCubit>().empty();
                              context.read<DailyDurationCubit>().empty();
                              context.read<DisplayDropDownCubit>().empty();
                              context.read<NotifificationChoiceCubit>().empty();
                              return true;
                            },
                            child: Container(
                              height: height * 0.65,
                              width: width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(borderRadius),
                                  gradient: LinearGradient(
                                    colors: [colors1[1], colors1[2]],
                                  )),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          "Task Type : ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.zero,
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: LinearGradient(colors: [colors1[2], colors[0]])),
                                          height: height * 0.05,
                                          child: Theme(
                                            data: Theme.of(context).copyWith(
                                              canvasColor: Colors.blue.shade200,
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                alignment: Alignment.center,
                                                menuMaxHeight: height * 0.2,
                                                value: context.read<DisplayDropDownCubit>().state,
                                                items: [
                                                  DropdownMenuItem(
                                                    alignment: Alignment.center,
                                                    value: dropDownItem1,
                                                    child: Text(dropDownItem1),
                                                  ),
                                                  DropdownMenuItem(
                                                    alignment: Alignment.center,
                                                    value: dropDownItem2,
                                                    child: Text(dropDownItem2),
                                                  ),
                                                ],
                                                onChanged: ((value) async {
                                                  context.read<DisplayDropDownCubit>().changeValue(value!);
                                                  if (value != "Daily") {
                                                    omniStart = await showOmniDateTimePicker(
                                                      displayTitle: const Text(
                                                        "Start Date-Time",
                                                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                                      ),
                                                      context: context,
                                                      startFirstDate: DateTime.now(),
                                                      startLastDate: DateTime(2025, 1, 1, 0, 0),
                                                      startInitialDate: DateTime.now(),
                                                    );
                                                    omniEnd = await showOmniDateTimePicker(
                                                      displayTitle: const Text(
                                                        "End Date-Time",
                                                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                                      ),
                                                      context: context,
                                                      startFirstDate: omniStart,
                                                      startLastDate: DateTime(2025, 1, 1, 0, 0),
                                                      startInitialDate: omniStart,
                                                    );
                                                    if (durationState.isEmpty) {
                                                      context.read<RangeDurationCubit>().addDateTime([omniStart, omniEnd]);
                                                    } else {
                                                      context.read<RangeDurationCubit>().replaceDateTime([omniStart, omniEnd]);
                                                    }

                                                    if (context.read<RangeDurationCubit>().state.isNotEmpty) {
                                                      displayDate1 =
                                                          "${context.read<RangeDurationCubit>().state[0]?.day}/${context.read<RangeDurationCubit>().state[0]?.month}/${context.read<RangeDurationCubit>().state[0]?.year}";
                                                      displayDate2 =
                                                          "${context.read<RangeDurationCubit>().state[1]?.day}/${context.read<RangeDurationCubit>().state[1]?.month}/${context.read<RangeDurationCubit>().state[1]?.year}";
                                                    }

                                                    durationDays = context.read<RangeDurationCubit>().state[1]?.difference(context.read<RangeDurationCubit>().state[0]!).inDays;
                                                    durationHours = context.read<RangeDurationCubit>().state[1]?.difference(context.read<RangeDurationCubit>().state[0]!).inHours;
                                                    durationMinutes = context.read<RangeDurationCubit>().state[1]?.difference(context.read<RangeDurationCubit>().state[0]!).inMinutes;
                                                    displayDate = durationDays == 0 ? "Date: $displayDate1" : "$displayDate1-$displayDate2";
                                                    dropDownItem2 = displayDate;
                                                    context.read<DisplayDropDownCubit>().changeValue(displayDate);
                                                    print(context.read<RangeDurationCubit>().state);
                                                    print(displayDate1);
                                                    print(displayDate2);
                                                  } else {
                                                    dailyTime1 = await showTimePicker(
                                                      context: context,
                                                      initialTime: const TimeOfDay(hour: 0, minute: 0),
                                                      confirmText: "Next",
                                                      helpText: "Start Time Of Task",
                                                    );
                                                    dailyTime2 = await showTimePicker(
                                                      context: context,
                                                      initialTime: dailyTime1!,
                                                      helpText: "End Time Of Task",
                                                    );
                                                    context.read<DailyDurationCubit>().addTime([dailyTime1, dailyTime2]);

                                                    durationDays = 0;
                                                    durationHours = context.read<DailyDurationCubit>().state[1]!.hour - context.read<DailyDurationCubit>().state[0]!.hour;
                                                    durationMinutes = durationHours != 0
                                                        ? (context.read<DailyDurationCubit>().state[1]!.minute) % (durationHours! * 60)
                                                        : context.read<DailyDurationCubit>().state[1]!.minute;

                                                    print(context.read<DailyDurationCubit>().state);
                                                    print(durationHours);
                                                    print(durationMinutes);
                                                  }
                                                }),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height * 0.02),
                                    Container(
                                      child: (context.read<RangeDurationCubit>().state.isNotEmpty && durationHours != null && context.read<DisplayDropDownCubit>().state != "Daily")
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Text("Duration :"),
                                                durationDays != 0
                                                    ? Container(
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: LinearGradient(colors: [colors[0], colors[1]])),
                                                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text("Days : ", style: TextStyle(fontSize: fontSize, color: colors[2])),
                                                            Text("$durationDays", style: GoogleFonts.frederickaTheGreat(fontSize: fontSize, color: Colors.white, fontWeight: FontWeight.bold)),
                                                            Text(" Hours : ", style: TextStyle(fontSize: fontSize, color: colors[2])),
                                                            Text(
                                                              "${(durationHours! - 24 * durationDays!) < 10 ? zero : empty}${durationHours! - 24 * durationDays!} : ${(durationMinutes! - 60 * durationHours!) < 10 ? "0" : " "}${durationMinutes! - 60 * durationHours!}",
                                                              style: GoogleFonts.frederickaTheGreat(fontSize: fontSize, color: Colors.white, fontWeight: FontWeight.bold),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : Container(
                                                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: LinearGradient(colors: [colors[0], colors[1]])),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text("Hours : ", style: TextStyle(fontSize: fontSize + 2, color: colors[2])),
                                                            Text(
                                                              "${(durationHours! - 24 * durationDays!) < 10 ? zero : empty}${durationHours! - 24 * durationDays!} : ${(durationMinutes! - 60 * durationHours!) < 10 ? "0" : " "}${durationMinutes! - 60 * durationHours!}",
                                                              style: GoogleFonts.frederickaTheGreat(fontSize: fontSize + 2, color: Colors.white, fontWeight: FontWeight.bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              ],
                                            )
                                          : Container(),
                                    ),
                                    Container(
                                      child: (context.read<DailyDurationCubit>().state.isNotEmpty && durationHours != null && context.read<DisplayDropDownCubit>().state == "Daily")
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Text("Duration"),
                                                Container(
                                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: LinearGradient(colors: [colors[0], colors[1]])),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text("Hours : ", style: TextStyle(fontSize: fontSize + 2, color: colors[2])),
                                                      Text("${durationHours! < 10 ? "0" : ""}$durationHours : ${durationMinutes! < 10 ? "0" : ""}$durationMinutes",
                                                          style: GoogleFonts.frederickaTheGreat(fontSize: fontSize + 2, color: Colors.white, fontWeight: FontWeight.bold)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : SizedBox(
                                              height: height * 0.03,
                                            ),
                                    ),
                                    SizedBox(height: height * 0.02),
                                    Form(
                                      key: formKey,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: durationDays == null || durationDays == 0 ? width * 0.6 : width * 0.7,
                                            height: height * 0.05,
                                            child: TextFormField(
                                              expands: true,
                                              minLines: null,
                                              maxLines: null,
                                              textAlignVertical: TextAlignVertical.top,
                                              textInputAction: TextInputAction.done,
                                              keyboardType: TextInputType.multiline,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return "Please enter the  task Name";
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                name = value;
                                              },
                                              controller: taskName,
                                              decoration: InputDecoration(
                                                alignLabelWithHint: true,
                                                contentPadding: const EdgeInsets.all(5.0),
                                                label: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text("Name of the Task"),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.02),
                                          SizedBox(
                                            width: durationDays == null || durationDays == 0 ? width * 0.6 : width * 0.7,
                                            height: height * 0.2,
                                            child: TextFormField(
                                              expands: true,
                                              textAlignVertical: TextAlignVertical.top,
                                              minLines: null,
                                              maxLines: null,
                                              keyboardType: TextInputType.multiline,
                                              controller: taskDescription,
                                              onChanged: (value) {
                                                description = value;
                                              },
                                              decoration: InputDecoration(
                                                label: const Text("Description (optional)"),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.02),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const Text("Select Frequency of Notifications:"),
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  OutlinedButton(
                                                    style: ButtonStyle(
                                                      overlayColor: MaterialStatePropertyAll(buttonColors[1]),
                                                      fixedSize: MaterialStatePropertyAll(Size(width * 0.65, height * 0.01)),
                                                      // side: MaterialStatePropertyAll(BorderSide(color: Colors.blue.shade400, style: BorderStyle.solid, width: 1.0, strokeAlign: StrokeAlign.outside)),
                                                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                                                      backgroundColor:
                                                          context.read<NotifificationChoiceCubit>().state == 1 ? MaterialStatePropertyAll(buttonColors[1]) : MaterialStatePropertyAll(buttonColors[0]),
                                                    ),
                                                    onPressed: () {
                                                      context.read<NotifificationChoiceCubit>().selectFrequency(1);
                                                    },
                                                    child: Text("Every Hour", style: TextStyle(color: Colors.blue.shade800)),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.05,
                                                  ),
                                                  OutlinedButton(
                                                    style: ButtonStyle(
                                                      fixedSize: MaterialStatePropertyAll(Size(width * 0.65, height * 0.01)),
                                                      // side: MaterialStatePropertyAll(BorderSide(color: Colors.blue.shade400, style: BorderStyle.solid, width: 1.0, strokeAlign: StrokeAlign.outside)),
                                                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                                                      backgroundColor:
                                                          context.read<NotifificationChoiceCubit>().state == 2 ? MaterialStatePropertyAll(buttonColors[1]) : MaterialStatePropertyAll(buttonColors[0]),
                                                    ),
                                                    onPressed: () {
                                                      context.read<NotifificationChoiceCubit>().selectFrequency(2);
                                                    },
                                                    child: Text("on Completion", style: TextStyle(color: Colors.blue.shade800)),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      });
}

showError(String? errorMessage, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(errorMessage.toString()),
          actions: <Widget>[
            MaterialButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
