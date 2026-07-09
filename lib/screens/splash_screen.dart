import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ২ সেকেন্ড পর হোম স্ক্রিনে যাওয়ার লজিক
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.blueAccent, // আপনি চাইলে ব্যাকগ্রাউন্ড কালারও বদলাতে পারেন
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // মাঝখানের আইকন
            Icon(Icons.api_rounded, size: 100, color: Colors.white),
            SizedBox(height: 20),

            // 👇 ঠিক এই লাইনটিতে আপনার অ্যাপের নাম পরিবর্তন করুন 👇
            Text(
              'API Data Explorer',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),

            SizedBox(height: 10),
            Text(
              'Flutter Assignment Project', // এখানে একটি ছোট সাবটাইটেলও যোগ করে দিলাম
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
