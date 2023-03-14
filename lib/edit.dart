import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_list/data.dart';
import 'package:task_list/main.dart';

const taskBoxName = 'tasks';

class EditTaskScreen extends StatefulWidget {
  final TaskEntity task;

  EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.task.name);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        title: Text('Edit Task'),
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TaskEntity task = TaskEntity();
          widget.task.name = _controller.text;
          widget.task.priority = widget.task.priority;
          if (widget.task.isInBox) {
            widget.task.save();
          } else {
            final Box<TaskEntity> box = Hive.box(taskBoxName);
            box.add(widget.task);
          }
          Navigator.pop(context);
        },
        label: Row(
          children: const [
            Text(
              'save changes',
            ),
            Icon(
              CupertinoIcons.check_mark,
              size: 19,
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                flex: 1,
                child: PriorityCheckBox(
                  onTap: () {
                    setState(() {
                      widget.task.priority = Priority.high;
                    });
                  },
                  lable: 'High',
                  color: primaryColor,
                  isSelected: widget.task.priority == Priority.high,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                flex: 1,
                child: PriorityCheckBox(
                  onTap: () {
                    setState(() {
                      widget.task.priority = Priority.normal;
                    });
                  },
                  lable: 'Normal',
                  color: noramlPriorityColor,
                  isSelected: widget.task.priority == Priority.normal,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                flex: 1,
                child: PriorityCheckBox(
                  onTap: () {
                    setState(() {
                      widget.task.priority = Priority.low;
                    });
                  },
                  lable: 'Low',
                  color: lowPriorityColor,
                  isSelected: widget.task.priority == Priority.low,
                ),
              ),
            ],
          ),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              label: Text(
                'Add a task for today ...',
                style:
                    themeData.textTheme.bodyText1!.apply(fontSizeFactor: 1.2),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String lable;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  const PriorityCheckBox(
      {super.key,
      required this.lable,
      required this.color,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: secondaryTextColor.withOpacity(0.2),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(lable),
            ),
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: _CheckBoxShape(
                  value: isSelected,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckBoxShape extends StatelessWidget {
  final bool value;
  final color;

  const _CheckBoxShape({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themeData.colorScheme.onPrimary,
              size: 16,
            )
          : null,
    );
  }
}
