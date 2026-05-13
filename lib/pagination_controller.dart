import 'package:flutter/material.dart';
import 'package:essential_demo/user_detail_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class ImageGalleryPage extends StatefulWidget {
  @override
  _ImageGalleryPageState createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  final PageController _controller = PageController();

  final List<PageData> pages = [
    PageData(

      title: "Minimalist Nature",
      description: "Serene landscapes that focus on simplicity and calm.",
    ),
    PageData(

      title: "Cyberpunk City",
      description: "Neon-drenched streets and futuristic urban energy.",
    ),
    PageData(

      title: "Cozy Interior",
      description: "Warm, inviting spaces designed for comfort and hygge.",
    ),
    PageData(

      title: "Vibrant Abstract",
      description: "A burst of colors and textures that spark creativity.",
    ),
    PageData(

      title: "Aerial Ocean",
      description: "Stunning top-down views of crystal clear turquoise waves.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Feed View")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. ITEMS AT THE TOP ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome Back!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text("Check out today's featured galleries below.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            // --- 2. THE IMAGE GALLERY (Now with fixed height) ---
            SizedBox(
              height: 350, // Set height so it doesn't try to fill the whole screen
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _controller,
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),

                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pages[index].title,
                                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    pages[index].description,
                                    style: TextStyle(color: Colors.white70, fontSize: 14),
                                  ),
                                  SizedBox(height: 30), // Space for indicator dots
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Indicators positioned relative to the gallery box
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _controller,
                        count: pages.length,
                        effect: const WormEffect(
                          dotHeight: 10,
                          dotWidth: 10,
                          spacing: 12,
                          dotColor: Colors.white54,
                          activeDotColor: Colors.blue,
                        ),
                        onDotClicked: (index) => _controller.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- 3. ITEMS AT THE BOTTOM ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("More Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
                  SizedBox(height: 20),
                  // Example of more content
                  ListView.builder(
                    shrinkWrap: true, // Necessary inside SingleChildScrollView
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, i) => ListTile(

                      title: Text("Related Item ${i + 1}"),
                      subtitle: Text("Subtitle for related content"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
