import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:retailer_frontend/SignIn.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(
          child:Lottie.asset("assets/lottie/Animation - 1743702335349.json")
          ),
          
          Text(
          'Smart Supply',
          style: TextStyle(
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontStyle:FontStyle.italic
            
          ),
        ),
        ],
      ),
      nextScreen:  CreateAccountScreenRetailer(),
backgroundColor: Color.fromARGB(255, 68, 10, 228),
splashIconSize: 300,
    );
  }
}