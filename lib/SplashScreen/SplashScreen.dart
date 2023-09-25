import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../HomeScreen/HomeScreen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[400],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display the first Lottie animation
            Lottie.asset(
              'assets/images/animo.json',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              repeat: true,
            ), // Adjust properties as needed

            SizedBox(height: 20),

            // Display the second Lottie animation
            GestureDetector(
              onTap: (){ Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => HomeScreen(),
                ),
              );},
              child: Lottie.asset(
                'assets/images/start.json',
                width: 200,
                height: 200,
              ),
            ),


          ],
        ),
      ),
    );
  }
}
