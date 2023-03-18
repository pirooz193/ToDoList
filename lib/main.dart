import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/data/source/hive_task_source.dart';

import 'screens/edit/edit.dart';
import 'screens/home/home.dart';

// const taskBoxName = 'tasks';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: primaryContainer),
  );
  runApp(ChangeNotifierProvider<Repository<TaskEntity>>(
      create: (context) =>
          Repository<TaskEntity>(HiveTaskDatasource(Hive.box(taskBoxName))),
      child: const MyApp()));
}

final primaryColor = Color(0xff794CFF);
final primaryContainer = Color(0xff5C0AFF);
final primaryTextColor = Color(0xff1D2830);
final secondaryTextColor = Color(0xffAFBED0);
final Color noramlPriorityColor = Color(0xffF09819);
final Color lowPriorityColor = Color(0xff3BE1F1);
final Color highPriorityColor = primaryColor;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          const TextTheme(
            headline6: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: secondaryTextColor,
          ),
          iconColor: secondaryTextColor,
          border: InputBorder.none,
        ),
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          primaryContainer: primaryContainer,
          background: Color(0xffF3F5F8),
          onSurface: primaryTextColor,
          onBackground: primaryTextColor,
          secondary: primaryColor,
          onSecondary: Colors.white,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
