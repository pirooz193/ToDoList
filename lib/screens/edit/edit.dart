import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/main.dart';
import 'package:task_list/screens/edit/cubit/edittask_cubit.dart';

const taskBoxName = 'tasks';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({
    super.key,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController(
        text: context.read<EditTaskCubit>().state.task.name);
    super.initState();
  }

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
          context.read<EditTaskCubit>().onSavedChangesClick();
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
          BlocBuilder<EditTaskCubit, EditTaskState>(
            builder: (context, state) {
              final priority = state.task.priority;
              return Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      onTap: () {
                        context
                            .read<EditTaskCubit>()
                            .onPriorityChanged(Priority.high);
                      },
                      lable: 'High',
                      color: primaryColor,
                      isSelected: priority == Priority.high,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      onTap: () {
                        context
                            .read<EditTaskCubit>()
                            .onPriorityChanged(Priority.normal);
                      },
                      lable: 'Normal',
                      color: noramlPriorityColor,
                      isSelected: priority == Priority.normal,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      onTap: () {
                        context
                            .read<EditTaskCubit>()
                            .onPriorityChanged(Priority.low);
                      },
                      lable: 'Low',
                      color: lowPriorityColor,
                      isSelected: priority == Priority.low,
                    ),
                  ),
                ],
              );
            },
          ),
          TextField(
            controller: _controller,
            onChanged: (value) {
              context.read<EditTaskCubit>().onTextChanged(_controller.text);
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
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
