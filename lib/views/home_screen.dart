import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager_app/bloc/task_manager_bloc.dart';
import 'package:task_manager_app/services/tasks_manager.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   int _selectedBottomNavIndex = 0;
  // final List<Widget> _pages = [
  //   PendingTaskPage(),
  //   CompletedTaskPage(),
  //   FavouriteTaskPage(),
  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskManagerBloc>().add(LoadTasksEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Task Manager App"),
        actions: [
          //IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.card_travel_rounded),
              title: Text('My Tasks'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.restore_from_trash),
              title: Text('Bin'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                context.go('/login');
              },
            ),
          ],
        ),
      ),
      body:_selectedBottomNavIndex == 0
          ? const PendingTaskPage()
          : _selectedBottomNavIndex == 1
          ? const CompletedTaskPage()
          : const FavouriteTaskPage(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return AddTasksScreen();
              }));
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.grey,
        currentIndex: _selectedBottomNavIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomNavIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Icons.incomplete_circle_outlined),
              label: "Pending Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: "Completed Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favourite Tasks"),
        ],
      ),
    );
  }
}


class PendingTaskPage extends StatelessWidget {
  const PendingTaskPage({super.key});

  @override
  Widget build(BuildContext context) {

    int _selectedBottomNavIndex = 0;

    //pending tasks section

    return BlocBuilder<TaskManagerBloc, TaskManagerState>(builder: (BuildContext context, TaskManagerState state) {
      if (state is TasksLoading) {
        return Center(child: CircularProgressIndicator(),);
      } else if (state is TasksLoaded) {
        final tasks = state.tasks;
        final completedTasks = state.completedTasks;
        if (_selectedBottomNavIndex == 0) {
          final pendingTasks = List.generate(tasks.length, (index) => index)
              .where((index) => !completedTasks.contains(index))
              .toList();

          return ListView.builder(
            itemCount: pendingTasks.length,
            itemBuilder: (BuildContext context, int index) {
              final taskIndex = pendingTasks[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white60,
                  elevation: 2,
                  child: ListTile(
                    title: Text(tasks[taskIndex]),
                    subtitle: Text(state.descriptions.length > taskIndex ? state.descriptions[taskIndex] : "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: Checkbox(value: false, onChanged: (_) {
                      context.read<TaskManagerBloc>().add(ToggleTasksEvent(
                          taskIndex));
                    }),
                    trailing: IconButton(onPressed: () {
                      context.read<TaskManagerBloc>().add(DeleteTasksEvent(
                          taskIndex));
                    }, icon: Icon(Icons.delete)),
                      onTap: () {}
                  ),
                ),
              );
            },
          );
        }
      }
      return Center(child: Text("No Tasks Available"),);
    }
      );
  }
}

class CompletedTaskPage extends StatelessWidget {
  const CompletedTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<TaskManagerBloc, TaskManagerState>(
      builder: (context, state) {
        if (state is TasksLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TasksLoaded) {
          final tasks = state.tasks;
          final completedTasks = state.completedTasks;

          if (completedTasks.isEmpty) {
            return const Center(child: Text("No Completed Tasks"));
          }

          return ListView.builder(
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              final taskIndex = completedTasks[index];
              return ListTile(
                title: Text(tasks[taskIndex]),
                leading: Checkbox(
                  value: true,
                  onChanged: (_) {
                    context
                        .read<TaskManagerBloc>()
                        .add(ToggleTasksEvent(taskIndex));
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context
                        .read<TaskManagerBloc>()
                        .add(DeleteTasksEvent(taskIndex));
                  },
                ),
              );
            },
          );
        }
        return const Center(child: Text("No Tasks Available"));
      },
    );
  }
}

class FavouriteTaskPage extends StatelessWidget {
  const FavouriteTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
      return BlocBuilder<TaskManagerBloc, TaskManagerState>(
      builder: (context, state) {
        if (state is TasksLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TasksLoaded) {
          // For now, assuming favourite tasks are not implemented
          // You can replace this with actual favourite tasks logic
          return const Center(
            child: Text("Favourite Tasks"),
          );
        }
        return const Center(
          child: Text("No Tasks Available"),
        );
      },
    );
  }
}

class AddTasksScreen extends StatefulWidget {
  const AddTasksScreen({super.key});

  @override
  State<AddTasksScreen> createState() => _AddTasksScreenState();
}

class _AddTasksScreenState extends State<AddTasksScreen> {
  final TextEditingController taskTitleController = TextEditingController();
  final TextEditingController taskDescriptionController = TextEditingController();
  final TextEditingController taskDueDateController = TextEditingController();

  final maxTaskTitleLength = 50;
  final maxTaskDescriptionLength = 500;

  String selectedTaskPriority = "Low";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text("Add New Task"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLength: maxTaskTitleLength,
                controller: taskTitleController,
                decoration: const InputDecoration(
                  labelText: "Task Title",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLength: maxTaskDescriptionLength,
                controller: taskDescriptionController,
                decoration: const InputDecoration(
                  labelText: "Task Description",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: taskDueDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Task Due Date",
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      taskDueDateController.text =
                          picked.toIso8601String().split("T").first;
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: selectedTaskPriority,
                items: ["Low", "Medium", "High"].map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTaskPriority = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Priority",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Cancel"),
                ),

                const SizedBox(width: 70),

                ElevatedButton(
                  onPressed: () {
                    final taskTitle = taskTitleController.text.trim();
                    if (taskTitle.isNotEmpty) {
                      context.read<TaskManagerBloc>().add(
                        AddTaskEvent(
                          taskTitleController.text,
                          taskDescriptionController.text,
                          taskDueDateController.text,
                          selectedTaskPriority,
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Task title cannot be empty'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class TaskDetailsPage extends StatelessWidget {

  final Map<String, String> task;
  const TaskDetailsPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text("Task Details",style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}



