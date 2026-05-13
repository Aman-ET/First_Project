

import 'package:flutter/material.dart';
import 'package:essential_demo/grid_detail_view.dart';
import 'package:essential_demo/login_view.dart';

/*
class Product {
  const Product({required this.name, required this.price, required this.inStock});

  final String name;
  final double price;
  final bool inStock;
}

*/

class SignupView extends StatelessWidget{
  final String name;
  // final Product car;
  const SignupView({super.key, required this.name, });



  @override
  Widget build(BuildContext context) {
    return Column(
        // mainAxisAlignment: .center,
        mainAxisSize: .max,
        children: [
          ButtonWidget(name: name),

        ],

    );
  }


}

class ButtonWidget extends StatefulWidget {
  final String name;
  const ButtonWidget({super.key, required this.name});
  // const ButtonWidget({ key, this.name }): super(key: key);


  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

/*
class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.name);
  }
} */


class _ButtonWidgetState extends State<ButtonWidget> {
  String _buttonText = 'Click Me!';



  void _handlePress() {
    setState(() {
      _buttonText = 'Button Pressed!';
    });
    print("Elevated Button Pressed!"); // Prints to the console
  }

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: MyGridView(),
    );
  }
}


class MyGridView extends StatelessWidget {
  const MyGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String?>> items = [
      {"image": "assets/images/android_icon.png", "name": "Android"},
      {"image": "assets/images/atandt.png", "name": "Atandt"},
      {"image": "assets/images/etsy.png", "name": "Etsy"},
      {"image": "assets/images/facebook.png", "name": "Facebook"},
      {"image": "assets/images/icon.png", "name": "Icon"},
      {"image": "assets/images/instagram.png", "name": "Instagram"},
      {"image": "assets/images/photoshop.png", "name": "Photoshop"},
      {"image": "assets/images/profile.png", "name": "Profile"},
      {"image": "assets/images/twitter.png", "name": "Twitter"},
      {"image": "assets/images/whatsapp.png", "name": "Whatsapp"},
    ];
    return GridView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              // Your action here: the 'index' variable holds the selected item's position
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      GridDetailView(name: items.elementAt(index)['name']!),
                ),
              );

              // You can also pass this index to a callback function or change the state
            },

          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  items[index]["image"]!,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                items[index]["name"]!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        );
      },
    );
  }
}
