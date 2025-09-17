part of 'task_manager_bloc.dart';

abstract class TaskManagerState {}

final class TaskManagerInitial extends TaskManagerState {}

class TasksLoading extends TaskManagerState {}

class TasksLoaded extends TaskManagerState {

   List<String> tasks = [];
   List<int> completedTasks = [];
   final List<String> descriptions;


   TasksLoaded(this.tasks, this.completedTasks,this.descriptions);
}
