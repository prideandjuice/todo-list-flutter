import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 242, 251),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 158, 238),
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            color: const Color.fromARGB(255, 68, 24, 71),
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TaskSearchDelegate(taskProvider),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(taskProvider.tasks[index].title), // Unik untuk setiap tugas
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              taskProvider.deleteTask(index);
            },
            child: TaskTile(index: index, task: taskProvider.tasks[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 226, 158, 238),
        child: const Icon(Icons.add, color: Color.fromARGB(255, 68, 24, 71)),
        onPressed: () => _showAddTaskDialog(context, taskProvider),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, TaskProvider taskProvider) {
    final TextEditingController _taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.add, color: Colors.deepPurple),
              SizedBox(width: 10),
              Text('Tambah Tugas', style: TextStyle(color: Colors.deepPurple)),
            ],
          ),
          backgroundColor: Colors.white,
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(hintText: "Masukkan tugas"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.deepPurple)),
            ),
            TextButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  taskProvider.addTask(_taskController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Tambah', style: TextStyle(color: Colors.deepPurple)),
            ),
          ],
        );
      },
    );
  }
}

// Search Delegate untuk pencarian tugas
class TaskSearchDelegate extends SearchDelegate {
  final TaskProvider taskProvider;
  TaskSearchDelegate(this.taskProvider);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredTasks = taskProvider.tasks
        .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return ListTile(
          title: Text(task.title),
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              taskProvider.toggleTask(index);
              (context as Element).markNeedsBuild();
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              taskProvider.deleteTask(index);
              (context as Element).markNeedsBuild();
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

