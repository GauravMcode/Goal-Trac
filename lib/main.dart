import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scheduleyourday/Logic/LogicComponent.dart';
import 'Screens/HomePage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Model/Task.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>("Schedules");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ListofTasksCubit(),
        ),
        BlocProvider(
          create: (context) => RangeDurationCubit(),
        ),
        BlocProvider(
          create: (context) => DisplayDropDownCubit(),
        ),
        BlocProvider(
          create: (context) => DailyDurationCubit(),
        ),
        BlocProvider(
          create: (context) => NotifificationChoiceCubit(),
        ),
        BlocProvider(
          create: (context) => ExpandItCubit(),
        ),
        BlocProvider(
          create: (context) => ExpandTasksList(),
        ),
        BlocProvider(
          create: (context) => BottomSheetShownCubit(),
        ),
      ],
      child: MaterialApp(
        title: "schedule app",
        // darkTheme: ThemeData.dark(),
        theme: ThemeData(
          primarySwatch: Colors.brown,
          textTheme: Themes[0],
        ),

        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}

List<TextTheme> Themes = [
  GoogleFonts.pacificoTextTheme(), //small hand written type
  GoogleFonts.dancingScriptTextTheme(), //small hand written type
];
