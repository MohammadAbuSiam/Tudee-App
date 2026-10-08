import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tudee_app/screens/add_task_screen.dart';

class HomePage extends StatefulWidget {
  final String name;

  const HomePage({
    super.key,
    required this.name,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    final box = Hive.box('tasksbox');

    final savedTasks = box.get(
      'tasks_${widget.name}',
      defaultValue: [],
    );

    setState(() {
      tasks = List.from(savedTasks);
    });
  }

  Future<void> _openAddTaskPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(
          name: widget.name,
        ),
      ),
    );

    if (result == true) {
      _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffe8e8),

      appBar: AppBar(
        backgroundColor: const Color(0xff48b3e5),
        elevation: 0,

        title: const Text(
          'Tudee',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Welcome
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'Welcome ${widget.name}',
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      // Done
                      Expanded(
                        child: Container(
                          height: 65,

                          color: const Color(0xff70c49b),

                          child: const Center(
                            child: Text(
                              'Done\n0',
                              textAlign: TextAlign.center,

                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      // To-do
                      Expanded(
                        child: Container(
                          height: 65,

                          color: const Color(0xff9180ed),

                          child: Center(
                            child: Text(
                              'To-do\n${tasks.length}',
                              textAlign: TextAlign.center,

                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Tasks
            if (tasks.isEmpty)
              Container(
                width: double.infinity,
                height: 94,

                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),

                child: const Text(
                  'No tasks for today!\n'
                  'Tap the + button to add your first one.',

                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,

                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 10,
                      ),

                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Text(
                        tasks[index]['title'],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),

      // Floating Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff3eb1e4),

        onPressed: _openAddTaskPage,

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}