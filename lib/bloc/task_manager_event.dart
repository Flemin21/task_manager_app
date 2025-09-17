part of 'task_manager_bloc.dart';

abstract class TaskManagerEvent {}

// Load Saved Tasks (Shared Preferences)
class LoadTasksEvent extends TaskManagerEvent {}

// Add New Tasks
class AddTaskEvent extends TaskManagerEvent {

  late final String title;
  late final String description;
  AddTaskEvent(this.title, this.description);
}

// Toggle Tasks (Completed / Uncompleted)
class ToggleTasksEvent extends TaskManagerEvent{

  late final int toggleTaskIndex;

  ToggleTasksEvent(this.toggleTaskIndex);
}

// Delete Tasks
class DeleteTasksEvent extends TaskManagerEvent{

  late final int deleteTask;

  DeleteTasksEvent(this.deleteTask);
}
