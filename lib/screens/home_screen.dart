import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatelessWidget {
  final String name;

  HomePage({required this.name});

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('tasksBox');

    List tasks = box.get(
      'tasks_$name',
      defaultValue: [],
    );

    return Scaffold(
      backgroundColor: Color(0xffffe8e8),

      appBar: AppBar(
        backgroundColor: Color(0xff48b3e5),
        title: Text('Tudee'),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // Welcome
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    'Welcome $name',
                    style: TextStyle(fontSize: 13),
                  ),

                  SizedBox(height: 8),

                  Row(
                    children: [

                      // Done
                      Expanded(
                        child: Container(
                          height: 65,
                          color: Color(0xff70c49b),

                          child: Center(
                            child: Text(
                              'Done\n0',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 6),

                      // To-do
                      Expanded(
                        child: Container(
                          height: 65,
                          color: Color(0xff9180ed),

                          child: Center(
                            child: Text(
                              'To-do\n${tasks.length}',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 12),

            // Tasks
            if (tasks.isEmpty)

              Container(
                width: double.infinity,
                height: 94,

                padding: EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Text(
                  'No tasks for today!\n'
                  'Tap the + button to add your first one.',
                  style: TextStyle(fontSize: 11),
                ),
              )

            else

              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,

                  itemBuilder: (context, index) {

                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(12),

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

      // زر الإضافة
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff3eb1e4),

        onPressed: () {
          // سنضيف Task هنا لاحقًا
        },

        child: Icon(Icons.add),
      ),
    );
  }
}