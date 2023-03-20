import 'package:flutter/material.dart';
import 'package:task_list/data/source/source.dart';

class Repository<T> extends ChangeNotifier implements DataSource<T> {
  final DataSource<T> localDatasource;

  Repository(this.localDatasource);

  @override
  Future<T> createOrUpdate(T data) async {
    Future<T> savedTask = localDatasource.createOrUpdate(data);
    notifyListeners();
    return savedTask;
  }

  @override
  Future<void> delete(data) async {
    localDatasource.delete(data);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async {
    await localDatasource.deleteAll();
    notifyListeners();
  }

  @override
  Future<void> deleteById(id) async {
    localDatasource.deleteById(id);
  }

  @override
  Future<T> findById(dynamic id) async {
    return localDatasource.findById(id);
  }

  @override
  Future<List<T>> getAll({String searchKeyword = ''}) async {
    return localDatasource.getAll(searchKeyword: searchKeyword);
  }
}
