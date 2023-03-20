import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/source/source.dart';

class HiveTaskDatasource implements DataSource<TaskEntity> {
  final Box<TaskEntity> box;

  HiveTaskDatasource(this.box);

  @override
  Future<TaskEntity> createOrUpdate(data) async {
    if (data.isInBox) {
      data.save();
    } else {
      data.id = await box.add(data);
    }
    return data;
  }

  @override
  Future<void> delete(data) async {
    box.delete(data);
  }

  @override
  Future<void> deleteAll() async {
    box.clear();
  }

  @override
  Future<void> deleteById(id) async {
    box.delete(id);
  }

  @override
  Future<TaskEntity> findById(id) async {
    return box.values.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<TaskEntity>> getAll({String searchKeyword = ''}) async {
    if (searchKeyword.isNotEmpty) {
      return box.values
          .where((element) => element.name.contains(searchKeyword))
          .toList();
    } else {
      return box.values.toList();
    }
  }
}
