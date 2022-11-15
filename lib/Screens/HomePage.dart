import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scheduleyourday/Screens/Logic/LogicComponent.dart';
import 'package:scheduleyourday/view_Methods/Schedule.dart';
import 'package:scheduleyourday/Model/Task.dart';
import 'package:scheduleyourday/Screens/Logic/boxes.dart';
import '../view_Methods/custompaints.dart';
import '../view_Methods/LogoAnimations.dart';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void initState() {
    super.initState();
    // final box = Boxes.getSchedules();
    // box.clear();

    animationStatus1 ??= "";
    scalingLogo ??= 0.0;
    transformLogo ??= 0.0;
    fadeLogo ??= 0.0;

    _animationController2 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _animationController3 = AnimationController(vsync: this, reverseDuration: Duration(milliseconds: 1500), value: 1.0);
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
      _animationController1 = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
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

    Future<Widget> bottomSheet(BuildContext context, double height, double width, {int scheduleNo = 1}) async {
      context.read<BottomSheetShownCubit>().openSheet();
      setState(() {});
      print(scheduleNo);
      return await showModalBottomSheet(
        enableDrag: false,
        elevation: 100.0,
        isDismissible: false,
        barrierColor: Color.fromARGB(0, 150, 16, 16),
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

    return BlocBuilder<BottomSheetShownCubit, bool>(
      builder: (context, state) {
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
                  : logoFadeWidget(height, width, _animation3, scalingLogo, transformLogo),
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
                      top: height * 0.15 * (1 - _animationController3.value),
                      left: 0,
                      // bottom: height * 0.05 * (1 - _animationController3.value),
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
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: listOfKeys.length != 0
                                    ? AnimatedContainer(
                                        curve: Curves.ease,
                                        duration: Duration(milliseconds: 1000),
                                        height: height * 0.05 * (1 - _animationController3.value),
                                        width: width,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(gradient: LinearGradient(colors: colors1)),
                                        child: Text("Schedules: ",
                                            style: TextStyle(
                                              fontSize: 20,
                                            )),
                                      )
                                    : Container(),
                              ),
                              AnimatedContainer(
                                padding: EdgeInsets.only(left: width * 0.1),
                                duration: Duration(milliseconds: 1000),
                                curve: Curves.ease,
                                width: width,
                                height: height * 0.8 * (1 - _animationController3.value),
                                child: ListView(
                                    children: List.generate(keysList.length, (index) {
                                  String s = keysList[index].toString();
                                  int schedule = int.parse(s);
                                  List<Task> tasksList = box.values.where((element) => element.taskID == schedule).toList();
                                  return Column(
                                    children: [
                                      CustomPaint(
                                        painter: LogoCustomPainter1(false),
                                        child: Container(
                                          // padding: EdgeInsets.only(right: width * 0.1),
                                          alignment: Alignment.topCenter,
                                          width: width * 0.85,
                                          height: height * 0.35,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: height * 0.025,
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: width * 0.1,
                                                      ),
                                                      Container(
                                                        width: width * 0.25,
                                                        alignment: Alignment.topRight,
                                                        child: Text(
                                                          "Schedule ${index + 1}",
                                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                  ),
                                                  Center(
                                                    child: Text("Tasks(${tasksList.length}):", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(10.0),
                                                    margin: EdgeInsets.only(left: width * 0.01),
                                                    decoration: BoxDecoration(gradient: LinearGradient(colors: [colors[0], colors[1]]), borderRadius: BorderRadius.circular(20.0)),
                                                    width: width * 0.4,
                                                    height: height * 0.15,
                                                    child: Scrollbar(
                                                      interactive: true,
                                                      child: ListView.builder(
                                                          itemCount: tasksList.length,
                                                          itemBuilder: ((context, index) {
                                                            return Container(
                                                              width: width * 0.2,
                                                              height: height * 0.05,
                                                              child: Scrollbar(
                                                                interactive: true,
                                                                child: ListView(
                                                                  scrollDirection: Axis.horizontal,
                                                                  children: [
                                                                    Text(tasksList[index].taskName),
                                                                    SizedBox(
                                                                      width: width * 0.01,
                                                                    ),
                                                                    Text(" : ${tasksList[index].type == "1" ? "Daily" : "Range of Dates"}"),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          })),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: width * 0.05,
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(gradient: LinearGradient(colors: [colors[0], colors[1]]), shape: BoxShape.circle),
                                                        child: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              setCreateValues(width, height);
                                                            });
                                                            bottomSheet(context, height, width, scheduleNo: schedule);
                                                          },
                                                          icon: Icon(Icons.edit_note_outlined),
                                                          iconSize: 100,
                                                          color: colors1[1],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.05,
                                      )
                                    ],
                                  );
                                })),
                              ),
                            ],
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

    // ignore: dead_code
  }
}
