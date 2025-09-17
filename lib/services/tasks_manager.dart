import 'package:shared_preferences/shared_preferences.dart';

class   TaskManager {
  static const String _tasks = "tasks";
  static const String _completedTasks = "completed";
  static const String _descriptions = "descriptions";
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

  Future<void> clearTasks() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_tasks);
    await sharedPreferences.remove(_completedTasks);
  }
}
