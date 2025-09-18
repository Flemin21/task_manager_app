import 'package:shared_preferences/shared_preferences.dart';

class   TaskManager {
  static const String _tasks = "tasks";
  static const String _completedTasks = "completed";
  static const String _descriptions = "descriptions";
  static const String _taskDueDates = "dueDates";
  static const String _taskPriorityStatus = "priorities";
  Future<bool> saveTasks(List<String> tasks) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setStringList(_tasks, tasks);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> getTasks() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(_tasks) ?? [];
  }

  Future<void> saveCompleted(List<int> completedIndexes) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList(
      _completedTasks,
      completedIndexes.map((e) => e.toString()).toList(),
    );
  }

  Future<List<int>> getCompleted() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final list = sharedPreferences.getStringList(_completedTasks) ?? [];
    return list.map((e) => int.parse(e)).toList();
  }

  Future<bool> saveDescriptions(List<String> descriptions) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setStringList(_descriptions, descriptions);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> getDescriptions() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(_descriptions) ?? [];
  }

  Future<bool> saveTaskDueDates(List<String> dueDates) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setStringList(_taskDueDates, dueDates);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> getTaskDueDates() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(_taskDueDates) ?? [];
  }

  Future<bool> saveTaskPriorityStatus(List<String> priorities) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setStringList(_taskPriorityStatus, priorities);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> getTaskPriorityStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(_taskPriorityStatus) ?? [];
  }

  Future<void> clearTasks() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_tasks);
    await sharedPreferences.remove(_completedTasks);
    await sharedPreferences.remove(_taskDueDates);
    await sharedPreferences.remove(_taskPriorityStatus);
  }
}
