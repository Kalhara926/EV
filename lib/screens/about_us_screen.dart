import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme for colors

    return Scaffold(
      extendBodyBehindAppBar: true, // Allow body to extend behind the AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.black87), // Darker icon for visibility
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.black87), // Darker text for visibility
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Gradient (Similar to HomeScreen for consistency, or adjust as needed)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE0E0E0),
                  Colors.white
                ], // Light grey to white
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20.0,
              MediaQuery.of(context).padding.top +
                  kToolbarHeight +
                  20, // Adjust padding to account for AppBar
              20.0,
              20.0,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center content horizontally
              children: <Widget>[
                // Image/Illustration Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors
                        .white, // White background for the illustration section
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // --- START: Replaced with your about.png image ---
                      Image.asset(
                        'assets/about.png', // Your actual image asset path
                        height: 150, // Adjust height as needed for your image
                        width: 250, // Adjust width as needed for your image
                        fit: BoxFit
                            .contain, // Ensures the image fits within bounds
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback if image not found – helpful for debugging
                          return const Icon(Icons.broken_image,
                              size: 100, color: Colors.red);
                        },
                      ),
                      // --- END: Replaced with your about.png image ---
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Main Text Content
                Text(
                  'Welcome to EV charger, your trusted partner in powering the future of sustainable mobility.\n\n'
                  'We are committed to revolutionizing electric vehicle charging by offering fast, reliable, and eco-friendly charging solutions across Sri Lanka. Our platform connects EV drivers with a growing network of smart charging stations, ensuring convenience, efficiency, and innovation every step of the way.\n\n'
                  'Driven by technology and sustainability, we strive to make green transportation accessible to all.\n',
                  textAlign: TextAlign.justify, // Justify text as in the image
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: Colors.black87),
                ),
                const SizedBox(height: 20),

                // Learn More Button
                SizedBox(
                  width: double.infinity, // Make button full width
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle "Learn More" action, e.g., open a website,
                      // navigate to another screen with more details, etc.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Learn More button pressed!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme
                          .primaryColor, // Use primary color for the button
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Learn More',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Add some space at the bottom
              ],
            ),
          ),
        ],
      ),
    );
  }
}
