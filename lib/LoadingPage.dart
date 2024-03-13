import 'dart:async';
import 'package:flutter/material.dart';
import 'accueil.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool hasInternet = true; // Assume internet is initially available

  @override
  void initState() {
    super.initState();
    checkInternet();
  }

  Future<void> checkInternet() async {

    // Delay for 5 seconds
    await Future.delayed(Duration(seconds: 5));

    // Navigate to the next page or perform other actions based on internet availability
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(13, 28, 59, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo here
            Image.asset(
              'assets/tirelire.png',
              width: 190,
              height: 190,
              // Adjust width and height according to your logo size
            ),
            SizedBox(height: 30),
            // Loading animation
            CircularProgressIndicator(
              color: Colors.white, // Change the color as needed
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
