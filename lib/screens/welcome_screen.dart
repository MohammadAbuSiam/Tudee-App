import 'package:flutter/material.dart';
import 'package:tudee_app/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  TextEditingController nameController = TextEditingController();

  void saveName() async {

    String name = nameController.text;

    if (name.isEmpty) {
      return;
    }

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setString('username', name);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(name: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffe8e8),

      appBar: AppBar(
        backgroundColor: Color(0xff48b3e5),
        

        title: Text(
          'Tudee',
          style: GoogleFonts.cherryBombOne(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,)
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            SizedBox(height: 5),

            Text(
              "Let's get started",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 12),

            Text(
              'What should we call you?',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

            SizedBox(height: 12),

            TextField(
              controller: nameController,

              decoration: InputDecoration(
                hintText: 'Your name',

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 48,

              child: ElevatedButton(
                onPressed: saveName,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff48b3e5),
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                child: Text(
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