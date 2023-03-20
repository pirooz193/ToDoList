import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';

part 'edittask_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  final TaskEntity _task;
  final Repository<TaskEntity> repository;
  EditTaskCubit(this._task, this.repository) : super(EdittaskInitial(_task));

  void onSavedChangesClick() {
    repository.createOrUpdate(_task);
  }

  void onTextChanged(String changeText) {
    _task.name = changeText;
  }

  void onPriorityChanged(Priority changedPriority) {
    _task.priority = changedPriority;
    emit(EditTaskProrityChange(_task));
  }
}
