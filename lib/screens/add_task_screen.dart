import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddTaskPage extends StatefulWidget {
  final String name;

  const AddTaskPage({
    super.key,
    required this.name,
  });

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _taskController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    final title = _taskController.text.trim();

    if (title.isEmpty) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final box = Hive.box('tasksbox');

    final List tasks = List.from(
      box.get(
        'tasks_${widget.name}',
        defaultValue: [],
      ),
    );

    tasks.add({
      'title': title,
      'isDone': false,
    });

    await box.put(
      'tasks_${widget.name}',
      tasks,
    );

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffe8e8),

      appBar: AppBar(
        backgroundColor: const Color(0xff48b3e5),
        elevation: 0,
        automaticallyImplyLeading: false,
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
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  'Add Task',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Container(
                  width: 28,
                  height: 28,

                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),

                  child: const Icon(
                    Icons.assignment_add,
                    size: 20,
                    color: Color(0xff263238),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            TextField(
              controller: _taskController,

              decoration: InputDecoration(
                hintText: 'What needs to be done?',
                hintStyle: const TextStyle(
                  color: Color(0xff7c8791),
                  fontSize: 12,
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 15,
                ),
              ),

              textInputAction: TextInputAction.done,

              onSubmitted: (_) {
                _saveTask();
              },
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 45,

              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveTask,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3eb1e4),
                  foregroundColor: Colors.white,

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),

                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}