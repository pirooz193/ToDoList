import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data.dart';
import 'package:task_list/edit.dart';

const taskBoxName = 'tasks';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: primaryContainer),
  );
  runApp(const MyApp());
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
          TextTheme(
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

class HomeScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final box = Hive.box<TaskEntity>(taskBoxName);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditTaskScreen(
                task: TaskEntity(),
              ),
            ),
          );
        },
        label: Row(
          children: [
            Text("Add New Task"),
            SizedBox(
              width: 4,
            ),
            Icon(CupertinoIcons.add),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeData.colorScheme.primary,
                    themeData.colorScheme.primaryContainer
                  ],
                ),
              ),
              padding: EdgeInsets.all(12),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'To Do List',
                      style: themeData.textTheme.headline6!
                          .apply(color: themeData.colorScheme.onPrimary),
                    ),
                    Icon(
                      CupertinoIcons.share,
                      color: themeData.colorScheme.onPrimary,
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    color: themeData.colorScheme.onPrimary,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black.withOpacity(0.1),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                      ),
                      label: Text('Search task...'),
                    ),
                  ),
                )
              ]),
            ),
            Expanded(
              child: ValueListenableBuilder<Box<TaskEntity>>(
                valueListenable: box.listenable(),
                builder: (context, box, child) {
                  if (box.isNotEmpty) {
                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
                      itemCount: box.values.length + 1,
                      itemBuilder: ((context, index) {
                        if (index == 0) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Today',
                                    style: themeData.textTheme.headline6!
                                        .apply(fontSizeFactor: 0.8),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 4),
                                    width: 70,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: themeData.colorScheme.primary,
                                      borderRadius: BorderRadius.circular(1.5),
                                    ),
                                  ),
                                ],
                              ),
                              MaterialButton(
                                onPressed: () {
                                  box.clear();
                                },
                                textColor: secondaryTextColor,
                                elevation: 0,
                                color: Color(0xffEAEFF5),
                                child: Row(
                                  children: const [
                                    Text("Delete All"),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Icon(
                                      CupertinoIcons.delete_solid,
                                      size: 18,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          final TaskEntity task =
                              box.values.toList()[index - 1];
                          return TaskItem(task: task);
                        }
                      }),
                    );
                  } else {
                    return const EmptyState();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/empty_state.svg',
          width: 120,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text('Your task is empty !'),
      ],
    );
  }
}

class TaskItem extends StatefulWidget {
  static const double height = 84;
  static const double borderRadius = 8;
  const TaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final priorityColor;
    switch (widget.task.priority) {
      case Priority.low:
        priorityColor = lowPriorityColor;
        break;
      case Priority.normal:
        priorityColor = noramlPriorityColor;
        break;
      case Priority.high:
        priorityColor = highPriorityColor;
        break;
    }

    return InkWell(
      onTap: () {
        setState(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditTaskScreen(task: widget.task),
            ),
          );
        });
      },
      onLongPress: () {
        widget.task.delete();
      },
      child: Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.only(left: 16),
        height: TaskItem.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TaskItem.borderRadius),
          color: themeData.colorScheme.surface,
        ),
        child: Row(
          children: [
            MyCheckBox(
              onTap: () {
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                });
              },
              value: widget.task.isCompleted,
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                widget.task.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 24,
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              width: 4,
              height: 84,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(TaskItem.borderRadius),
                  bottomRight: Radius.circular(TaskItem.borderRadius),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final bool value;
  final GestureTapCallback onTap;

  const MyCheckBox({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: !value
              ? Border.all(
                  color: secondaryTextColor,
                  width: 2,
                )
              : null,
          color: value ? primaryColor : null,
        ),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                color: themeData.colorScheme.onPrimary,
                size: 16,
              )
            : null,
      ),
    );
  }
}
