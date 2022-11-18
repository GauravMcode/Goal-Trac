import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scheduleyourday/Logic/LogicComponent.dart';
import 'package:scheduleyourday/Screens/ScheduleDetails.dart';
import 'package:scheduleyourday/view_Methods/Schedule.dart';
import 'package:scheduleyourday/Model/Task.dart';
import 'package:scheduleyourday/Logic/boxes.dart';
import '../view_Methods/custompaints.dart';
import '../view_Methods/LogoAnimations.dart';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:page_transition/page_transition.dart';
import 'package:data_table_2/data_table_2.dart';

//maintain 2
List<Color> colors = [
  Color.fromARGB(255, 72, 142, 255),
  Color.fromARGB(255, 60, 59, 59),
  Color.fromARGB(255, 255, 239, 9),
];
List<Color> colors1 = [
  Colors.amber,
  Color.fromARGB(255, 255, 222, 102),
  Color.fromARGB(255, 255, 171, 107),
];
List<Color> colors2 = [
  // Colors.lightBlue.shade100,
  // Color.fromARGB(255, 251, 234, 106),
  Color.fromARGB(255, 255, 40, 219),

  Color.fromARGB(255, 93, 1, 109),
];

List<Color> statusColors = [
  Color.fromARGB(255, 0, 84, 3),
  Color.fromARGB(255, 255, 27, 10),
  Colors.yellow,
];

bool? isCompleted = false;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController1;
  late AnimationController _animationController2;
  late final AnimationController _animationController3;
  var _animation3;
  var animationStatus1;

  double? scalingLogo;
  double? transformLogo;
  double? fadeLogo;

  int animation1Duration = 3500;
  int animation2Duration = 2000;
  int animation3Duration = 1000;

  @override
  void initState() {
    super.initState();
    // final box = Boxes.getSchedules();
    // box.clear();

    animationStatus1 ??= "";
    scalingLogo ??= 0.0;
    transformLogo ??= 0.0;
    fadeLogo ??= 0.0;

    _animationController2 = AnimationController(vsync: this, duration: Duration(milliseconds: animation2Duration));
    _animationController3 = AnimationController(vsync: this, reverseDuration: Duration(milliseconds: animation3Duration), value: 1.0);
    context.read<DateTimeNowCubit>().emitDateTime();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController1.dispose();
    _animationController2.dispose();
    _animationController3.dispose();

    Hive.close();
  }

  double? createWidth;
  double? createHeight;
  String? createText;
  Color? createColor;

  setCreateValues(double width, double height) {
    createWidth = createWidth == width * 0.3 ? width : width * 0.3;
    createHeight = createHeight == height / 20 ? height / 30 : height / 20;
    createText = createText == "Schedule" ? "New Schedule" : "Schedule";
    createColor = createColor == colors[0] ? colors[1] : colors[0];
  }

  @override
  Widget build(BuildContext context) {
    if (_animationController2.value == 0.0 && animationStatus1 != "AnimationStatus.completed") {
      _animationController1 = AnimationController(value: 0.58, vsync: this, duration: Duration(milliseconds: animation1Duration));
      _animationController1.forward();
    }

    _animationController1.addListener(() {
      scalingLogo = _animationController1.value;
      print(scalingLogo);
    });
    _animationController1.addStatusListener((status) {
      animationStatus1 = _animationController1.status.toString();
      if (animationStatus1 == "AnimationStatus.completed") {
        print(animationStatus1);

        setState(() {});
      }
    });
    if (animationStatus1 == "AnimationStatus.completed") {
      _animationController2.forward();
      _animationController2.addListener(() {
        transformLogo = _animationController2.value;
        print(transformLogo);
        if (_animationController2.value == 1.0) {
          setState(() {});
        }
      });
    }
    double widthLocal = MediaQuery.of(context).size.width;
    double heightLocal = MediaQuery.of(context).size.height;
    double width = math.min(widthLocal, heightLocal);
    double height = math.max(widthLocal, heightLocal);
    if (createHeight == null && createWidth == null && createText == null) {
      createWidth = width * 0.3;
      createHeight = height / 20;
      createText = "New Schedule";
      createColor = colors[0];
    }

    if (_animationController2.value == 1.0 && _animation3 == null) {
      _animationController3.reverse();
      _animation3 = CurvedAnimation(parent: _animationController3, curve: Curves.ease, reverseCurve: Curves.ease);
      print(_animation3);
    }
    if (!context.read<BottomSheetShownCubit>().state && createText == "Schedule") {
      setState(() {
        setCreateValues(width, height);
      });
    }
    // if (!context.read<BottomSheetShownCubit>().state && createText == "New ") {
    //   setState(() {
    //     setCreateValues(width, height);
    //   });
    // }

    Future<Widget> bottomSheet(BuildContext context, double height, double width, {int scheduleNo = 0}) async {
      context.read<BottomSheetShownCubit>().openSheet();
      AnimationController _animationController4 = AnimationController(vsync: this, duration: Duration(seconds: 1));
      _animationController4.forward;
      setState(() {});
      print(scheduleNo);
      return await showModalBottomSheet(
        transitionAnimationController: _animationController4,
        enableDrag: false,
        elevation: 40.0,
        isDismissible: false,
        // barrierColor: Color.fromARGB(0, 255, 253, 253),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colors[1], width: 3.0, strokeAlign: StrokeAlign.inside),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
        ),
        context: context,
        builder: ((context) {
          return WillPopScope(
            onWillPop: () async {
              context.read<BottomSheetShownCubit>().closedSheet();
              setState(() {});
              return true;
            },
            child: Container(
              padding: EdgeInsets.all(width * 0.025),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors[0], colors[1]]),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
              ),
              height: height * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MySchedule(scheduleNo),
                ],
              ),
            ),
          );
        }),
      );
    }

    Stream timeNow() async* {
      while (true) {
        await Future.delayed(Duration(seconds: 1));
        yield context.read<DateTimeNowCubit>().emitDateTime();
      }
    }

    // timeNow().listen(
    //   (event) => context.read<DateTimeNowCubit>().emitDateTime(),
    // );

    return BlocBuilder<BottomSheetShownCubit, bool>(
      builder: (context, boolState) {
        if (!context.read<BottomSheetShownCubit>().state && createText == "Schedule") {
          setCreateValues(width, height);
        }
        context.read<DateTimeNowCubit>().emitDateTime();

        return Scaffold(
          backgroundColor: colors[1],
          body: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                  animation: _animationController1,
                  builder: (context, child) {
                    return AnimatedBuilder(
                        animation: _animationController2,
                        builder: (context, child) {
                          return Container(
                            width: width,
                            height: height,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              stops: [0.0005, 0.9995],
                              transform: GradientRotation(math.pi * (0.4 * scalingLogo!) * (transformLogo != 0 ? (1 - transformLogo!) : 1.0)),
                              colors: colors2.reversed.toList(),
                              // center: Alignment(0.01, -0.3),
                              // focal: Alignment.center,focalRadius: 0.9,
                            )),
                          );
                        });
                  }),
              _animation3 == null
                  ? logoAppearWidget(height, width, _animationController1, _animationController2, _animationController3, scalingLogo, transformLogo)
                  : logoFadeWidget(height, width, _animation3, scalingLogo, transformLogo, _animationController3),
              Positioned(
                left: 0,
                top: height * 0.07,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (!context.read<BottomSheetShownCubit>().state && createText == "New Schedule") {
                      final box = Boxes.getSchedules();
                      List listOfKeys = [];
                      Map<dynamic, Task> mapAll = box.toMap();
                      if (mapAll.length != 0) {
                        mapAll.values.forEach((element) {
                          listOfKeys.add(element.taskID);
                        });
                      }
                      List Schedules = listOfKeys.toSet().toList();
                      bottomSheet(context, height, width, scheduleNo: Schedules.length);
                    }

                    setState(() {
                      setCreateValues(width, height);
                    });
                  },
                  child: AnimatedBuilder(
                      animation: _animationController1,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(-(1 - scalingLogo!) * width, 0),
                          child: CustomPaint(
                            painter: createSchedulePaint(),
                            child: AnimatedBuilder(
                                animation: _animationController2,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(-(1 - transformLogo!) * width, 0),
                                    child: AnimatedContainer(
                                      curve: Curves.ease,
                                      duration: Duration(milliseconds: 1000),
                                      height: createHeight,
                                      width: createWidth,
                                      alignment: createText == "Schedule" ? Alignment.center : Alignment.centerLeft,
                                      child: Text(
                                        createText.toString(),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.pacifico(fontSize: 16, color: colors[1], fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        );
                      }),
                ),
              ),
              AnimatedBuilder(
                  animation: _animation3 ?? _animationController3,
                  builder: (context, child) {
                    return Positioned(
                      top: height * 0.15,
                      left: 0,
                      right: 0,
                      // bottom: height * 0.3 * (1 - _animationController3.value),
                      child: ValueListenableBuilder<Box<Task>>(
                        valueListenable: Boxes.getSchedules().listenable(),
                        builder: (context, box, child) {
                          List listOfKeys = [];
                          Map<dynamic, Task> mapAll = box.toMap();
                          if (mapAll.length != 0) {
                            mapAll.values.forEach((element) {
                              listOfKeys.add(element.taskID);
                            });
                          }
                          print(listOfKeys);
                          //to get unique scheduleNo:
                          List keysList = listOfKeys.toSet().toList();
                          // if (listOfKeys.length != 0) {
                          //   for (var i = 1; i < listOfKeys.length; i++) {
                          //     if (listOfKeys[i] != listOfKeys[i - 1]) {
                          //       keysList.add(listOfKeys[i]);
                          //     }
                          //   }
                          // }
                          print(listOfKeys.toSet().toList());
                          print(keysList);
                          return Container(
                            width: width,
                            height: height,
                            child: ListView(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: listOfKeys.isNotEmpty
                                      ? AnimatedContainer(
                                          margin: EdgeInsets.only(right: width * _animationController3.value),
                                          curve: Curves.ease,
                                          duration: Duration(milliseconds: 400),
                                          height: height * 0.05,
                                          width: width,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(gradient: LinearGradient(colors: colors1)),
                                          child: const Text("Schedules: ", style: TextStyle(fontSize: 20)),
                                        )
                                      : Container(),
                                ),
                                SizedBox(height: height * 0.005),
                                AnimatedContainer(
                                  margin: EdgeInsets.only(left: width * _animationController3.value),
                                  alignment: Alignment.topLeft,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.ease,
                                  width: width * 2,
                                  height: height * 0.295,
                                  child: ScrollSnapList(
                                      onItemFocus: (p0) {},
                                      dynamicItemSize: true,
                                      itemSize: width * 0.5,
                                      itemCount: keysList.length,
                                      itemBuilder: ((context, index) {
                                        String s = keysList[index].toString();
                                        int schedule = int.parse(s);
                                        List<Task> tasksList = box.values.where((element) => element.taskID == schedule).toList();
                                        double Chieght = height * 0.28;
                                        double Cwidth = width * 0.5;
                                        return Column(
                                          children: [
                                            Card(
                                              elevation: 30,
                                              borderOnForeground: true,
                                              color: Color.fromARGB(0, 255, 255, 255),
                                              child: GlassmorphicContainer(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.all(5),
                                                blur: 10,
                                                borderGradient: LinearGradient(
                                                  colors: [Color(0xFF0FFFF).withOpacity(1), Color(0xFFFFFFF), Color(0xFF0FFFF).withOpacity(1)],
                                                ),
                                                linearGradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color(0xFF0FFFF).withOpacity(0.2),
                                                    Color(0xFF0FFFF).withOpacity(0.2),
                                                  ],
                                                ),
                                                border: 2,
                                                borderRadius: 20,
                                                height: Chieght,
                                                width: Cwidth,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        SizedBox(width: Cwidth * 0.025),
                                                        Text(
                                                          "Schedule ${index + 1}",
                                                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: colors[1]),
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: Cwidth * 0.025),
                                                            Padding(
                                                              padding: const EdgeInsets.all(5.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(gradient: LinearGradient(colors: [colors[0], colors[1]]), shape: BoxShape.circle),
                                                                child: IconButton(
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      setCreateValues(width, height);
                                                                    });
                                                                    bottomSheet(context, height, width, scheduleNo: schedule);
                                                                  },
                                                                  icon: Icon(Icons.edit_note_outlined),
                                                                  iconSize: 20,
                                                                  color: colors1[1],
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(gradient: LinearGradient(colors: [colors[0], colors[1]]), shape: BoxShape.circle),
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                          child: ScheduleDetails(schedule, index + 1),
                                                                          fullscreenDialog: true,
                                                                          reverseDuration: Duration(milliseconds: 600),
                                                                          duration: Duration(milliseconds: 800),
                                                                          alignment: Alignment(0.0, -0.5),
                                                                          type: PageTransitionType.size,
                                                                          childCurrent: widget)
                                                                      // MaterialPageRoute(builder: ((context) {
                                                                      //   return ScheduleDetails(schedule, index + 1);
                                                                      // })),
                                                                      );
                                                                },
                                                                icon: Icon(Icons.open_in_new_rounded),
                                                                iconSize: 20,
                                                                color: colors1[1],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: Chieght * 0.04),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        SizedBox(width: Cwidth * 0.3),
                                                        Container(
                                                            padding: EdgeInsets.all(5.0),
                                                            decoration: BoxDecoration(gradient: LinearGradient(colors: colors2), borderRadius: BorderRadius.circular(15)),
                                                            child: Text("Tasks(${tasksList.length}):",
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: colors1[0],
                                                                  fontWeight: FontWeight.bold,
                                                                ))),
                                                      ],
                                                    ),
                                                    SizedBox(height: Chieght * 0.02),
                                                    Container(
                                                      alignment: Alignment.topLeft,
                                                      padding: EdgeInsets.all(5.0),
                                                      margin: EdgeInsets.only(left: Cwidth * 0.025),
                                                      decoration: BoxDecoration(gradient: LinearGradient(colors: [colors[0], colors[1]]), borderRadius: BorderRadius.circular(20.0)),
                                                      width: Cwidth * 0.95,
                                                      height: Chieght * 0.5,
                                                      child: Scrollbar(
                                                        interactive: true,
                                                        child: ListView.builder(
                                                            itemCount: tasksList.length,
                                                            itemBuilder: ((context, index) {
                                                              return Row(
                                                                children: [
                                                                  Container(
                                                                    width: Cwidth * 0.62,
                                                                    child: SingleChildScrollView(
                                                                      scrollDirection: Axis.horizontal,
                                                                      child: Text(tasksList[index].taskName),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " : ${tasksList[index].type == "1" ? "Daily" : "Range"}",
                                                                    style: TextStyle(color: colors1[1]),
                                                                  ),
                                                                ],
                                                              );
                                                            })),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                // height: height * 0.05,
                                                )
                                          ],
                                        );
                                      })),
                                ),
                                AnimatedContainer(
                                  curve: Curves.ease,
                                  duration: Duration(milliseconds: 400),
                                  margin: EdgeInsets.only(top: width * 1.2 * _animationController3.value),
                                  child: Builder(builder: (context) {
                                    List<Task> todayTasksD = [];
                                    List<int> Dailykeys = [];
                                    // List<Task> todayTasksRcomp = []; // initial and present lies completely on present day
                                    // List<Task> todayTasksRstart = []; //range initial lies on present day
                                    // List<Task> todayTasksRend = []; //range end lies on present day
                                    // List<Task> todayTasksRin = []; //presentDay lies in the range
                                    List<Task> todayTasksR = [];
                                    List<int> Rangekeys = [];

                                    mapAll.values.forEach((element) {
                                      if (element.type == "1") {
                                        todayTasksD.add(element);
                                        Dailykeys.add(element.key);
                                      } else {
                                        if (element.dateTimeRange![0].toString().substring(0, 11) == context.read<DateTimeNowCubit>().state.toString().substring(0, 11) &&
                                            element.dateTimeRange![1].toString().substring(0, 11) == context.read<DateTimeNowCubit>().state.toString().substring(0, 11)) {
                                          todayTasksR.add(element);
                                          Rangekeys.add(element.key);
                                        } else if (element.dateTimeRange![0].toString().substring(0, 11) == DateTime.now().toString().substring(0, 11)) {
                                          todayTasksR.add(element);
                                          Rangekeys.add(element.key);
                                        } else if (element.dateTimeRange![1].toString().substring(0, 11) == DateTime.now().toString().substring(0, 11)) {
                                          Rangekeys.add(element.key);
                                          todayTasksR.add(element);
                                        } else if (element.dateTimeRange![1].difference(context.read<DateTimeNowCubit>().state).inHours > (24 - context.read<DateTimeNowCubit>().state.hour) &&
                                            context.read<DateTimeNowCubit>().state.difference(element.dateTimeRange![0]).inHours > context.read<DateTimeNowCubit>().state.hour) {
                                          Rangekeys.add(element.key);
                                          todayTasksR.add(element);
                                        }
                                      }
                                    });
                                    // todayTasksR.addAll(todayTasksRcomp);
                                    // todayTasksR.addAll(todayTasksRstart);
                                    // todayTasksR.addAll(todayTasksRend);
                                    // todayTasksR.addAll(todayTasksRin);
                                    return AnimatedBuilder(
                                        animation: _animationController3,
                                        builder: (context, child) {
                                          return Card(
                                            color: Color.fromARGB(0, 255, 255, 255),
                                            margin: EdgeInsets.only(left: width * 0.025, right: width * 0.025),
                                            elevation: 20,
                                            child: GlassmorphicContainer(
                                              width: width * 0.95,
                                              height: height,
                                              alignment: Alignment.topCenter,
                                              blur: 10,
                                              borderGradient: LinearGradient(colors: [Color(0xFF0FFFF).withOpacity(1), Color(0xFFFFFFF), Color(0xFF0FFFF).withOpacity(1)]),
                                              linearGradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [Color(0xFF0FFFF).withOpacity(0.2), Color(0xFF0FFFF).withOpacity(0.2)],
                                              ),
                                              border: 2,
                                              borderRadius: 20,
                                              child: Column(
                                                children: [
                                                  StreamBuilder(
                                                    stream: timeNow(),
                                                    builder: (context, child) {
                                                      return Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Text(
                                                              "${context.read<DateTimeNowCubit>().state.day}-${context.read<DateTimeNowCubit>().state.month}-${context.read<DateTimeNowCubit>().state.year}",
                                                              style: GoogleFonts.acme()),
                                                          Text("Today's Tasks"),
                                                          Text(
                                                              "${TimeOfDay.fromDateTime(context.read<DateTimeNowCubit>().state).format(context)} ${context.read<DateTimeNowCubit>().state.second} seconds",
                                                              style: GoogleFonts.acme()),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  Text("1. Daily Tasks"),
                                                  StreamBuilder(
                                                      stream: timeNow(),
                                                      builder: (context, snapshot) {
                                                        return Flexible(
                                                          flex: 1,
                                                          child: DataTable2(
                                                            columnSpacing: 0,
                                                            horizontalMargin: 0,
                                                            columns: [
                                                              DataColumn2(
                                                                label: Container(alignment: Alignment.center, height: height * 0.05, width: width * 0.28, color: Colors.yellow, child: Text("Tasks")),
                                                                fixedWidth: width * 0.28,
                                                              ),
                                                              DataColumn2(
                                                                label:
                                                                    Container(alignment: Alignment.center, height: height * 0.05, width: width * 0.18, color: Colors.yellow, child: Text("Start at")),
                                                                fixedWidth: width * 0.18,
                                                              ),
                                                              DataColumn2(
                                                                label:
                                                                    Container(alignment: Alignment.center, height: height * 0.05, width: width * 0.18, color: Colors.yellow, child: Text("Time Left")),
                                                                fixedWidth: width * 0.18,
                                                              ),
                                                              DataColumn2(
                                                                label: Container(alignment: Alignment.center, height: height * 0.05, width: width * 0.24, color: Colors.yellow, child: Text("status")),
                                                                fixedWidth: width * 0.24,
                                                              ),
                                                            ],
                                                            rows: List.generate(todayTasksD.length, (index) {
                                                              int leftHours = 0;
                                                              int leftMinutes = 0;
                                                              int presentHour = context.read<DateTimeNowCubit>().state.hour;
                                                              int presentMinutes = context.read<DateTimeNowCubit>().state.minute;
                                                              String startTime = todayTasksD[index].dailyTimeRange![0];
                                                              int startTimeHour = startTime.length == 7 ? int.parse(startTime.substring(0, 1)) : int.parse(startTime.substring(0, 2));
                                                              startTimeHour = startTime.substring(startTime.length - 2) == "AM" && startTimeHour == 12 ? 0 : startTimeHour;
                                                              startTimeHour = startTime.substring(startTime.length - 2) == "PM" ? startTimeHour + 12 : startTimeHour;
                                                              int startTimeMinutes = startTime.length == 7 ? int.parse(startTime.substring(2, 4)) : int.parse(startTime.substring(3, 5));
                                                              String endTime = todayTasksD[index].dailyTimeRange![1];
                                                              int endTimeHour = startTime.length == 7 ? int.parse(endTime.substring(0, 1)) : int.parse(startTime.substring(0, 2));
                                                              endTimeHour = endTime.substring(endTime.length - 2) == "AM" && endTimeHour == 12 ? 0 : endTimeHour;
                                                              endTimeHour = endTime.substring(endTime.length - 2) == "PM" ? endTimeHour + 12 : endTimeHour;
                                                              int endTimeMinutes = startTime.length == 7 ? int.parse(endTime.substring(2, 4)) : int.parse(endTime.substring(3, 5));
                                                              List<int> timeLeft = [leftHours, leftMinutes];
                                                              print("$startTimeHour : $startTimeMinutes present: $presentHour : $presentMinutes, end: $endTimeHour: $endTimeMinutes");
                                                              print(startTimeHour * 60 + startTimeMinutes);
                                                              print(presentHour * 60 + presentMinutes);
                                                              print(startTime.length);
                                                              print(int.parse(startTime.substring(3, 5)));

                                                              if ((startTimeHour * 60 + startTimeMinutes) > (presentHour * 60 + presentMinutes)) {
                                                                print("$index show duration");
                                                                //show duration
                                                                leftHours = endTimeHour - startTimeHour;
                                                                leftMinutes = ((60 * endTimeHour + endTimeMinutes) - (60 * startTimeHour + startTimeMinutes)) % 60;
                                                                print(leftMinutes);
                                                                timeLeft.clear();
                                                                timeLeft.addAll([leftHours, leftMinutes]);
                                                                // print(timeLeft);
                                                                print(timeLeft);
                                                              } else if ((startTimeHour * 60 + startTimeMinutes) <= (presentHour * 60 + presentMinutes) &&
                                                                  (presentHour * 60 + presentMinutes) < (endTimeHour * 60 + endTimeMinutes)) {
                                                                print("$index show time left");
                                                                //show time left -- else show 0:0
                                                                leftHours = endTimeHour - presentHour;
                                                                leftMinutes = ((60 * endTimeHour + endTimeMinutes) - (60 * presentHour + presentMinutes)) % 60;
                                                                timeLeft.clear();
                                                                timeLeft.addAll([
                                                                  (leftMinutes == 0 && leftHours != 0 ? leftHours - 1 : leftHours),
                                                                  (leftMinutes == 0 ? 59 : leftMinutes - 1),
                                                                  (60 - context.read<DateTimeNowCubit>().state.second - 1)
                                                                ]);
                                                              } else {
                                                                print("$index task ended");
                                                              }

                                                              return DataRow(cells: [
                                                                DataCell(Text(todayTasksD[index].taskName, style: GoogleFonts.acme())),
                                                                DataCell(Text(todayTasksD[index].dailyTimeRange![0], style: GoogleFonts.acme())),
                                                                DataCell(Text(
                                                                    "${timeLeft[0]}:${timeLeft[1] < 10 ? "0${timeLeft[1]}" : timeLeft[1]}${timeLeft.length == 3 ? ":${timeLeft[2] < 10 ? "0${timeLeft[2]}" : timeLeft[2]}" : ":00"}",
                                                                    style: GoogleFonts.acme())),
                                                                DataCell(
                                                                  timeLeft.length == 3
                                                                      ? Row(
                                                                          children: [
                                                                            Text("on-going",
                                                                                style: GoogleFonts.acme(
                                                                                  color: statusColors[0], //Color.fromARGB(255, 0, 84, 3), Color.fromARGB(255, 255, 27, 10),Colors.yellow
                                                                                )),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Icon(Icons.watch_later_outlined),
                                                                          ],
                                                                        )
                                                                      : timeLeft[0] == 0 && timeLeft[1] == 0
                                                                          ? todayTasksD[index].isCompleted![0]
                                                                              ? Row(children: [Text("completed", style: GoogleFonts.acme(color: statusColors[0])), Icon(Icons.check_box)])
                                                                              : Row(
                                                                                  children: [
                                                                                    Text("Done?", style: GoogleFonts.acme(color: statusColors[1])),
                                                                                    SizedBox(width: 11),
                                                                                    Checkbox(
                                                                                        tristate: false,
                                                                                        value: todayTasksD[index].isCompleted![0],
                                                                                        onChanged: ((value) {
                                                                                          box.put(
                                                                                              Dailykeys[index],
                                                                                              Task(
                                                                                                  todayTasksD[index].taskID,
                                                                                                  todayTasksD[index].taskName,
                                                                                                  todayTasksD[index].type,
                                                                                                  todayTasksD[index].notifyChoice,
                                                                                                  todayTasksD[index].description,
                                                                                                  todayTasksD[index].dailyTimeRange,
                                                                                                  todayTasksD[index].dateTimeRange,
                                                                                                  [true]));
                                                                                        }))
                                                                                  ],
                                                                                )
                                                                          : Row(
                                                                              children: [
                                                                                Text("Yet to Start", style: GoogleFonts.acme(color: statusColors[2])),
                                                                                SizedBox(width: 2),
                                                                                Icon(Icons.safety_check),
                                                                              ],
                                                                            ),
                                                                )
                                                              ]);
                                                            }),
                                                          ),
                                                        );
                                                      }),
                                                  SizedBox(
                                                    height: height * 0.05,
                                                  ),
                                                  Text("2. Specifice  Date Tasks"),
                                                  StreamBuilder(
                                                      stream: timeNow(),
                                                      builder: (context, snapshot) {
                                                        return Flexible(
                                                          flex: 1,
                                                          child: DataTable2(
                                                              columnSpacing: 0,
                                                              horizontalMargin: 10,
                                                              columns: [
                                                                DataColumn2(
                                                                  label: Container(alignment: Alignment.center, height: height * 0.05, width: width * 0.28, color: Colors.yellow, child: Text("Tasks")),
                                                                  fixedWidth: width * 0.28,
                                                                ),
                                                                DataColumn2(
                                                                  label: Container(
                                                                      alignment: Alignment.center, height: height * 0.05, width: width * 0.18, color: Colors.yellow, child: Text("Start Date")),
                                                                  fixedWidth: width * 0.18,
                                                                ),
                                                                DataColumn2(
                                                                  label:
                                                                      Container(alignment: Alignment.center, height: height * 0.05, width: width * 0.18, color: Colors.yellow, child: Text("End Date")),
                                                                  fixedWidth: width * 0.18,
                                                                ),
                                                                DataColumn2(
                                                                  label:
                                                                      Container(alignment: Alignment.center, height: height * 0.05, width: width * 0.24, color: Colors.yellow, child: Text("status")),
                                                                  fixedWidth: width * 0.24,
                                                                ),
                                                              ],
                                                              rows: List.generate(todayTasksR.length, (index) {
                                                                List<bool>? completedList = todayTasksR[index].isCompleted;
                                                                DateTime startTime = todayTasksR[index].dateTimeRange![0];
                                                                DateTime endTime = todayTasksR[index].dateTimeRange![1];
                                                                List Status = [];
                                                                if (context.read<DateTimeNowCubit>().state.difference(startTime).inSeconds < 0) {
                                                                  Status.add("Yet to Start");
                                                                  // completedList!.add(false);
                                                                } else if (context.read<DateTimeNowCubit>().state.difference(startTime).inSeconds >= 0 &&
                                                                    context.read<DateTimeNowCubit>().state.difference(endTime).inSeconds <= 0) {
                                                                  Status.add("In Progress");
                                                                  // completedList!.add(false);
                                                                } else {
                                                                  Status.add("Done?");
                                                                  // completedList!.add(false);
                                                                }
                                                                print(completedList);
                                                                print(Status);
                                                                return DataRow(cells: [
                                                                  DataCell(Text(todayTasksR[index].taskName, style: GoogleFonts.acme())),
                                                                  DataCell(Text("${startTime.day}/${startTime.month}/${startTime.year.toString().substring(2)}", style: GoogleFonts.acme())),
                                                                  DataCell(Text("${endTime.day}/${endTime.month}/${endTime.year.toString().substring(2)}", style: GoogleFonts.acme())),
                                                                  DataCell(Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Status[0] == "Done?"
                                                                          ? todayTasksR[index].isCompleted!.last
                                                                              ? Row(children: [Text("completed", style: GoogleFonts.acme(color: statusColors[0])), Icon(Icons.check_box)])
                                                                              : Row(
                                                                                  children: [
                                                                                    Text(Status[0], style: GoogleFonts.acme(color: statusColors[1])),
                                                                                    SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Checkbox(
                                                                                        tristate: false,
                                                                                        value: todayTasksR[index].isCompleted!.last,
                                                                                        onChanged: ((value) {
                                                                                          // completedList.replaceRange(completedList.length, completedList.length, [true]);
                                                                                          box.put(
                                                                                              Rangekeys[index],
                                                                                              Task(
                                                                                                todayTasksR[index].taskID,
                                                                                                todayTasksR[index].taskName,
                                                                                                todayTasksR[index].type,
                                                                                                todayTasksR[index].notifyChoice,
                                                                                                todayTasksR[index].description,
                                                                                                todayTasksR[index].dailyTimeRange,
                                                                                                todayTasksR[index].dateTimeRange,
                                                                                                [true],
                                                                                              ));
                                                                                        }))
                                                                                  ],
                                                                                )
                                                                          : Container(),
                                                                      Status[0] == "In Progress" ? Text(Status[0], style: GoogleFonts.acme(color: statusColors[0])) : Container(),
                                                                      Status[0] == "Yet to Start" ? Text(Status[0], style: GoogleFonts.acme(color: statusColors[2])) : Container(),
                                                                    ],
                                                                  )),
                                                                ]);
                                                              })),
                                                        );
                                                      }),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  }),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  })
            ],
          ),
        );
      },
    );
  }
}
