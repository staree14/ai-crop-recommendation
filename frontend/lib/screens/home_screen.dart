import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_app/widgets/feature_button.dart';
import 'package:farmer_app/screens/soil_data_screen.dart';
import 'package:farmer_app/screens/upload_screen.dart';
import 'package:farmer_app/screens/chat_screen.dart';
import 'package:farmer_app/screens/recommendations_screen.dart';
import 'package:farmer_app/screens/static_market_screen.dart';
import 'package:farmer_app/screens/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text(
    'Welcome to KrishiSathi!',
    style: TextStyle(fontWeight: FontWeight.bold),
  ).tr(),
  backgroundColor: Colors.green[700],
  centerTitle: true,
),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.green.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore Features',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ).tr(),
              SizedBox(height: 20),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  FeatureButton(
                    label: 'Soil Data',
                    imagePath: 'assets/images/soil.png',
                    navigateTo: SoilDataScreen(),
                  ),
                  FeatureButton(
                    label: 'Upload Crop Image',
                    imagePath: 'assets/images/leaf.png',
                    navigateTo: UploadScreen(),
                  ),
                  FeatureButton(
                    label: 'Chat & Voice',
                    imagePath: 'assets/images/chat.png',
                    navigateTo: ChatScreen(),
                  ),
                  FeatureButton(
                    label: 'Recommendations',
                    imagePath: 'assets/images/recommendation.png',
                    navigateTo: RecommendationsScreen(),
                  ),
                  FeatureButton(
                    label: 'Market & Weather',
                    imagePath: 'assets/images/market.png',
                    navigateTo: StaticMarketScreen(),
                  ),
                  FeatureButton(
                    label: 'Settings',
                    imagePath: 'assets/images/history.png',
                    navigateTo: SettingsScreen(),
                  ),
                ],
              ),

              SizedBox(height: 30),
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ).tr(),
              SizedBox(height: 16),

              AnimatedRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedRecentActivity extends StatefulWidget {
  const AnimatedRecentActivity({super.key});

  @override
  _AnimatedRecentActivityState createState() => _AnimatedRecentActivityState();
}

class _AnimatedRecentActivityState extends State<AnimatedRecentActivity> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideUp = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideUp,
        child: Container(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) => Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Container(
                width: 140,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade100, Colors.green.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.eco, size: 50, color: Colors.green[800]),
                    SizedBox(height: 12),
                    Text(
                      'Activity ${index + 1}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[900]),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Performed recently',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green[700]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
