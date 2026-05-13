import 'package:essential_demo/login_view.dart';
import 'package:essential_demo/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class HomeTabBarController extends StatefulWidget {
  const HomeTabBarController({super.key});
  @override
  HomeTabBarControllerState createState() => HomeTabBarControllerState();
}

class HomeTabBarControllerState extends State<HomeTabBarController> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/profile.png', height: 48),
              const SizedBox(width: 15),
              const Text('My Profile'),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurple[400],
          elevation: 0,
          // give the app bar rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          leading: Icon(
            Icons.menu,
          ),
        ),



        bottomNavigationBar: Material(
          color: Colors.deepPurple[600],
          child: TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: const [
              Tab(icon: Icon(Icons.directions_bike), text: 'Bike',),
              Tab(icon: Icon(Icons.directions_car), text: 'Car',),
              Tab(icon: Icon(Icons.cyclone), text: "Cyclone"),
              Tab(icon: Icon(Icons.home),text: 'Home',)
            ],
          ),
        ),


        body: TabBarView(
          children: [

            Container(
              color:  Colors.tealAccent,
              child: const Center(child: Text('Bike')),
            ),
            Container(
              color: Colors.cyan,
              child: const Center(child: Text('Car')),
            ),
            SignupView(name: "AMAN"),
            LoginView(),

          ],
        ),





/*
        body: Column(
          children: <Widget>[
            // construct the profile details widget here


            // the tab bar with two items
            SizedBox(
              height: 74,
              child: AppBar(
                bottom: TabBar(
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.red,
                  indicatorColor: Colors.black,

                  tabs: [
                    Tab(
                      icon: Icon(Icons.directions_bike),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.directions_car,
                      ),

                    ),
                    Tab(
                      icon: Icon(Icons.cyclone),
                      text: "Cyclone",
                    ),

                  ],
                ),
              ),
            ),

            // create widgets for each tab bar here
            Expanded(
              child: TabBarView(
                children: [
                  // first tab bar view widget
                  SignupView(name: "AMAN"),

                  LoginView(),

                  // second tab bar view widget
                  Container(
                    color: Colors.pink,
                    child: Center(
                      child: Text(
                        'Car',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),  */
      ),
    );
  }
}