import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/main.dart';
import 'package:task_list/screens/edit/cubit/edittask_cubit.dart';
import 'package:task_list/screens/edit/edit.dart';
import 'package:task_list/screens/home/bloc/task_list_bloc.dart';
import 'package:task_list/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<String> searchKeywordNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    // final box = Hive.box<TaskEntity>(taskBoxName);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider<EditTaskCubit>(
                create: (context) => EditTaskCubit(
                    TaskEntity(), context.read<Repository<TaskEntity>>()),
                child: EditTaskScreen(),
              ),
            ),
          );
        },
        label: Row(
          children: const [
            Text("Add New Task"),
            SizedBox(
              width: 4,
            ),
            Icon(CupertinoIcons.add),
          ],
        ),
      ),
      body: BlocProvider<TaskListBloc>(
        create: (context) =>
            TaskListBloc(context.read<Repository<TaskEntity>>()),
        child: SafeArea(
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
                    child: Builder(builder: (context) {
                      return TextField(
                        onChanged: (value) {
                          context
                              .read<TaskListBloc>()
                              .add(TaskListSearch(value));
                        },
                        controller: controller,
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          prefixIcon: Icon(
                            CupertinoIcons.search,
                          ),
                          label: Text('Search task...'),
                        ),
                      );
                    }),
                  )
                ]),
              ),
              Expanded(
                child: Consumer<Repository<TaskEntity>>(
                  builder: ((context, value, child) {
                    context.read<TaskListBloc>().add(TaskListStarted());
                    return BlocBuilder<TaskListBloc, TaskListState>(
                      builder: (context, state) {
                        if (state is TaskListSuccess) {
                          return TaskList(
                              items: state.items, themeData: themeData);
                        } else if (state is TaskListEmpty) {
                          return EmptyState();
                        } else if (state is TaskListLoading ||
                            state is TaskListInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is TaskListError) {
                          return Center(
                            child: Text(state.errorMessage),
                          );
                        } else {
                          throw Exception('state is not valid');
                        }
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.items,
    required this.themeData,
  }) : super(key: key);

  final items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: items.length + 1,
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
                  final taskrepository = Provider.of<Repository<TaskEntity>>(
                      context,
                      listen: false);
                  context.read<TaskListBloc>().add(TaskListDeleteAll());
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
          final TaskEntity task = items[index - 1];
          return TaskItem(task: task);
        }
      }),
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
              builder: (context) => BlocProvider<EditTaskCubit>(
                create: (context) => EditTaskCubit(
                    widget.task, context.read<Repository<TaskEntity>>()),
                child: const EditTaskScreen(),
              ),
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
