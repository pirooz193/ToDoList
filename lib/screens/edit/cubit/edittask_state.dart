part of 'edittask_cubit.dart';

@immutable
abstract class EditTaskState {
  final TaskEntity task;

  const EditTaskState(this.task);
}

class EdittaskInitial extends EditTaskState {
  const EdittaskInitial(super.task);
}

class EditTaskProrityChange extends EditTaskState {
  const EditTaskProrityChange(super.task);
}
