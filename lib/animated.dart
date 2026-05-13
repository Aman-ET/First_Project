import 'package:flutter/material.dart';

class MyAnimatedBox extends StatefulWidget {
  @override
  _MyAnimatedBoxState createState() => _MyAnimatedBoxState();
}

class _MyAnimatedBoxState extends State<MyAnimatedBox> {
  bool _isExpanded = false;

  void _toggleAnimation() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _closeAnimation() {
    setState(() {
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 300, // give space for animation
          width: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [


              Positioned(
                top: 200,
                child: ElevatedButton(
                  onPressed: _toggleAnimation,
                  child: const Text("Animate"),
                ),
              ),


              AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                width: _isExpanded ? 250 : 00,
                height: _isExpanded ? 200 : 00,
                decoration: BoxDecoration(
                  color: _isExpanded ? Colors.black : Colors.blue,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Text(
                        "Demo",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_isExpanded)
                      Positioned(
                        top: 5,
                        right: 5,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: _closeAnimation,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




