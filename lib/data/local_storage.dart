import 'package:flutter_todo_app/models/task_model.dart';
import 'package:hive/hive.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});
  Future<Task?> getTask({required String id});
  Future<List<Task>> getAllTasks();
  Future<bool> deleteTask({required Task task});
  Future<Task> updateTask({required Task task});
}

class HiveLocalStorage extends LocalStorage {
  late Box<Task> taskBox;

  HiveLocalStorage() {
    taskBox = Hive.box<Task>('ToDoApp');
  }

  @override
  Future<void> addTask({required Task task}) async {
    await taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    await task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTasks() async {
    List<Task> allTask = <Task>[];
    allTask = taskBox.values.toList();
    if (allTask.isNotEmpty) {
      allTask.sort(
        (Task a, Task b) => b.dateTime.compareTo(a.dateTime),
      );
    }
    return allTask;
  }

  @override
  Future<Task?> getTask({required String id}) async {
    if (taskBox.containsKey(id)) {
      return taskBox.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<Task> updateTask({required Task task}) async {
    await task.save();
    return task;
  }
}
