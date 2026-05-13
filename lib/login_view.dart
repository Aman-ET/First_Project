import 'package:essential_demo/animated.dart';
import 'package:essential_demo/signup_view.dart';
import 'package:essential_demo/splash_screen.dart';
import 'package:essential_demo/tabbar_controller.dart';
import 'package:essential_demo/user_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:essential_demo/database_connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:essential_demo/user_details.dart';
import 'package:essential_demo/Google_Map.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  @override
  void initState() {
    super.initState();
    initialization();
    fetchApiResponse();
    MapScreen();


  }

  void initialization() async {
    // Add your artificial delay here (e.g., 3 seconds)
    await Future.delayed(const Duration(seconds: 10));

    // Dismiss the splash screen
    FlutterNativeSplash.remove();
  }




  Future<List<UserDetails>> fetchApiResponse() async {
    final url = Uri.parse('https://fake-json-api.mock.beeceptor.com/users');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Successfully hit the API
        List<dynamic> body = jsonDecode(response.body);
        var data = jsonDecode(response.body);

        print('Response Data: $data');
        List<UserDetails> users = body.map((dynamic item) => UserDetails.fromJson(item)).toList();
        print("Test $users");
        return users;

      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to load users');
    }
  }





  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      // home: SplashScreen(),
      home: const LoginPage(title: 'Login'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _counter = 0;
  final nameTextController = TextEditingController();
  final ageTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String name = "";
  String age = "";
  String msg = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameTextController.dispose();
    ageTextController.dispose();
    _focusNode.dispose();

    super.dispose();
  }







  Future<void> _incrementCounter() async {
    // 1. Get values from controllers
    String currentName = nameTextController.text;
    String currentAge = ageTextController.text;
    int ageValue = int.tryParse(currentAge) ?? 0;

    // 2. Perform the ASYNC work outside setState
    // int id = await DatabaseHelper.instance.insertUsers({
    //   'name': currentName,
    //   'age': ageValue
    // });
    // bool isInserted = await DatabaseHelper.instance.insertOrUpdateUser(currentName, ageValue);


    // 3. Update UI synchronously
    setState(() {
      name = currentName;
      age = currentAge;
      _counter++;
      msg = 'Inserted: $currentName';
    });

    // 4. Navigate if successful
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserListView()),
    );
    // if (isInserted  && mounted) {
    //
    //   print("Database inserted");
    // }
    // else{
    //   print("Database updated");
    // }
  }



/*
  void _incrementCounter()  {
    setState(() async {
      name = nameTextController.text;
      age = ageTextController.text;
      int ageValue = int.tryParse(age) ?? 0;
      _counter++;
      msg = 'My name is ${nameTextController.text} My age is $age';
      int id = await DatabaseHelper.instance.insertUsers({'name': name, 'age': ageValue});

      if (id > 0) {
        print("Success! Inserted with ID: $id");
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  UserListView(),
            ),
          );
        }

      } else {
        print("Insertion failed.");
      }
    });
  }

 */

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    // Define colors based on the brightness mode
    final Color appBarColor = brightness == Brightness.dark
        ? Colors.grey[900]! // Color for dark mode
        : Colors.blue[500]!;
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: appBarColor,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              'Please Enter your Name:',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                backgroundColor: appBarColor, // Mirrors the AppBar color
                color: Colors.black,         // Ensures text is readable
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: nameTextController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your Name',
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Please Enter Your Age',
              style: TextStyle(
                color: Colors.white,
                backgroundColor: Colors.deepPurple,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 10),
            TextField(
              controller: ageTextController,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                // hintText: 'Enter Your Age',
                labelText: 'ENTER YOUR AGE',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Passward:',
              style: TextStyle(
                color: Colors.white,
                backgroundColor: Colors.deepPurple,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                // hintText: 'Enter Your Age',
                labelText: 'ENTER YOUR PASSWARD',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: _incrementCounter,
                child: const Text('Submit'),
              ),
            ),
            const SizedBox(height: 10),





            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          // MyAnimatedBox()
                      MapScreen()

                    ),
                  );
                },
                child: const Text('Signup'),
              ),
            ),



             /*


            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  // 1. Capture the data from your controllers
                  String currentName = nameTextController.text;
                  int newAge = int.tryParse(ageTextController.text) ?? 0;

                  // 2. Perform the update in the database
                  // We search by the name typed in the box and update the record
                  int rowsAffected = await DatabaseHelper.instance.updateUserByName(
                    currentName,
                    {'name': currentName, 'age': newAge},
                  );

                  // 3. Safety check for the 'async gap'
                  if (!mounted) {
                    if (rowsAffected > 0) {
                      // 4. Update the message on the screen
                      setState(() {
                        msg = "Updated $currentName successfully!";
                      });

                      // 5. Navigate to the list view to see the change
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserListView()),
                      );
                    } else {
                      setState(() {
                        msg = "Update failed: User '$currentName' not found.";
                      });
                    }
                  }
                },
                child: const Text('Signup (Update)'),
              ),
            ),
            */


            const SizedBox(height: 10),

            Text(msg, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple[300],
        currentIndex: 1,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        items: [BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Person"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "favorite"),
        ],
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
