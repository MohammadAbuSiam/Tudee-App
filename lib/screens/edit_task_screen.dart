import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditTaskPage extends StatefulWidget {
  final String name;
  final int taskIndex;
  final Map task;

  const EditTaskPage({
    super.key,
    required this.name,
    required this.taskIndex,
    required this.task,
  });

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController _taskController;

  late bool _isDone;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _taskController = TextEditingController(
      text: widget.task['title'] ?? '',
    );

    _isDone = widget.task['isDone'] ?? false;
  }

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

    tasks[widget.taskIndex] = {
      'title': title,
      'isDone': _isDone,
    };

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
                  'Edit Task',
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
                    Icons.edit,
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
            ),

            const SizedBox(height: 18),

            const Text(
              'Status',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _statusButton(
                    title: 'To-do',
                    isSelected: !_isDone,
                    onTap: () {
                      setState(() {
                        _isDone = false;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _statusButton(
                    title: 'Done',
                    isSelected: _isDone,
                    onTap: () {
                      setState(() {
                        _isDone = true;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

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

  Widget _statusButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 45,

        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xff3eb1e4)
              : Colors.white,

          borderRadius: BorderRadius.circular(25),

          border: Border.all(
            color: const Color(0xff3eb1e4),
            width: 1,
          ),
        ),

        alignment: Alignment.center,

        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : const Color(0xff3eb1e4),

            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
