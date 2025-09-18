import 'package:bloc/bloc.dart';
import '../services/tasks_manager.dart';

part 'task_manager_event.dart';
part 'task_manager_state.dart';

class TaskManagerBloc extends Bloc<TaskManagerEvent, TaskManagerState> {
  final TaskManager _taskManager = TaskManager();

  TaskManagerBloc() : super(TaskManagerInitial()) {
    on<LoadTasksEvent>((event, emit) async {
      emit(TasksLoading());

      final tasks = await _taskManager.getTasks();
      final descriptions = await _taskManager.getDescriptions();
      final completedTasks = await _taskManager.getCompleted();
      final taskDueDate = await _taskManager.getTaskDueDates();
      final taskPriority = await _taskManager.getTaskPriorityStatus();

      emit(TasksLoaded(tasks, completedTasks, descriptions, taskDueDate, taskPriority));
    });

    on<AddTaskEvent>((event, emit) async {
      if (state is TasksLoaded) {
        final currentState = state as TasksLoaded;

        final updatedTasks =
        List<String>.from(currentState.tasks)..add(event.title);
        final updatedDescriptions =
        List<String>.from(currentState.descriptions)..add(event.description);

        await _taskManager.saveTasks(updatedTasks);
        await _taskManager.saveDescriptions(updatedDescriptions);

        emit(TasksLoaded(
            updatedTasks, currentState.completedTasks, updatedDescriptions, currentState.taskDueDate, currentState.taskPriorityStatus));
      }
    });

    on<ToggleTasksEvent>((event, emit) async {
      if (state is TasksLoaded) {
        final currentState = state as TasksLoaded;
        final completedTasks = List<int>.from(currentState.completedTasks);

        if (completedTasks.contains(event.toggleTaskIndex)) {
          completedTasks.remove(event.toggleTaskIndex);
        } else {
          completedTasks.add(event.toggleTaskIndex);
        }

        await _taskManager.saveCompleted(completedTasks);

        emit(TasksLoaded(
            currentState.tasks, currentState.completedTasks, currentState.descriptions,currentState.taskDueDate,currentState.taskPriorityStatus));
      }
    });

    on<DeleteTasksEvent>((event, emit) async {
      if (state is TasksLoaded) {
        final currentState = state as TasksLoaded;

        final updatedTasks =
        List<String>.from(currentState.tasks)..removeAt(event.deleteTask);
        final updatedDescriptions =
        List<String>.from(currentState.descriptions)
          ..removeAt(event.deleteTask);

        final updatedCompletedTasks = currentState.completedTasks
            .where((deleteIndex) => deleteIndex != event.deleteTask)
            .map((deletedIndex) =>
        deletedIndex > event.deleteTask ? deletedIndex - 1 : deletedIndex)
            .toList();

        await _taskManager.saveTasks(updatedTasks);
        await _taskManager.saveDescriptions(updatedDescriptions);
        await _taskManager.saveCompleted(updatedCompletedTasks);

        emit(TasksLoaded(
            updatedTasks, updatedCompletedTasks, updatedDescriptions, currentState.taskDueDate, currentState.taskPriorityStatus));
      }
    });
  }
}
