import 'package:flutter/material.dart';


class GridDetailView extends StatelessWidget{
  final String name;
  // final Product car;
  const GridDetailView({super.key, required this.name, });



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, "Selected $name");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[300],
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                )
              ),

              child: Text(name, style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),),
            )
        )
      ),
    );
  }


}

