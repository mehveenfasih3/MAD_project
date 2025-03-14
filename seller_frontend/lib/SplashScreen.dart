import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:selller/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState(){
    super.initState();
    
    Timer(Duration(seconds: 4),(){Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (context)=> MyHomePage()));
    
    
    }
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      


    body: Container(
      color: Color.fromARGB(255, 104, 7, 114),
     
      child: Center(

        
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 85,
              backgroundImage: AssetImage("assets/Icons/LOGO2.jpg"),
            ),
            // Image.asset("assets/Icons/LOGO1.jpg",width: 150,repeat:ImageRepeat.repeat,), 
            SizedBox(height: 20),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Smart Supply',
                    speed: Duration(milliseconds: 200), 
                  ),
                ],
                totalRepeatCount: 1, 
              ),
            ),
          ],
        ),
      )
    ),
    );
 }
}