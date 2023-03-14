import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_list/data.dart';

const taskBoxName = 'tasks';

class EditTaskScreen extends StatelessWidget {
  TextEditingController _controller = TextEditingController();

  EditTaskScreen({super.key});
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
          TaskEntity task = TaskEntity();
          task.name = _controller.text;
          task.priority = Priority.low;
          if (task.isInBox) {
            task.save();
          } else {
            final Box<TaskEntity> box = Hive.box(taskBoxName);
            box.add(task);
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
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              label: Text(
                'Add a task for today',
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
