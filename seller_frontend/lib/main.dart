import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:selller/additem.dart';
import 'package:selller/alerts.dart';
import 'package:selller/prac.dart';
import 'package:http/http.dart'as http;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Supply' ,
      theme: ThemeData(
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


 

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String message = "Waiting for response...";

  Future<void> fetchData() async {
    final url = Uri.parse("http://127.0.0.1:5000/api?query=Hello");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          message = data["message"];  
        });
      } else {
        setState(() {
          message = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        message = "Failed to connect: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Smart Supply',style:  GoogleFonts.eagleLake(textStyle:TextStyle(fontSize: 24,fontStyle: FontStyle.italic,fontWeight: FontWeight.w900),)
        ),
        // actions: [
        //  Image(image: AssetImage('assets/Icons/image.png'),
        //  )  
        // ],
        backgroundColor: Color(0xFF8E6CEF),
        ),
        body: Center(
          child: Column(
            
          
          children: [
            SizedBox(height: 50,),
           
           Text('Scan Your Item',style:  GoogleFonts.abhayaLibre(textStyle:TextStyle(fontSize: 24,fontStyle: FontStyle.normal,fontWeight: FontWeight.w900),),
           ),
           Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
            color: Colors.white, // Background color
  border: Border.all(
    color: Colors.grey, // Border color
    width: 1.0, // Border width
  ),
  borderRadius: BorderRadius.circular(12.0), // Rounded corners
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1), 
      spreadRadius: 2, 
      blurRadius: 8, 
      offset: Offset(4, 4), 
    ),
  ],
            ),
           ),
SizedBox(height: 10,),
           ElevatedButton(
                              onPressed: () {
                                ();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> additem()));
                              },
                              child: Text("Scan Now!",style: TextStyle(color: Colors.black),),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF8E6CEF),
                              ),
                            ),
                             Text(message, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchData,
              child: Text("Get Message from Flask"),
            ),
          ]
          )
         ),

          
          
        
        drawer: Drawer(
          
          child: ListView(
            children:[
            const DrawerHeader( 
             decoration: BoxDecoration(color: Color(0xFF8E6CEF),
             
             ),
        child: Column(
          children: [
                              CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/avatar_placeholder.png'), // Placeholder for profile pic
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Mehveen Billionaire",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "messi@gmail.com",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
          ],
        ),
        
            ),
              ListTile(
                leading: Icon(Icons.scanner),
                title: Text('Scan Items'),
                onTap:   () {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => additem()));
        }),    
               ListTile(
                leading: Icon(Icons.smart_display),
                title: Text('Your Products'),
              ),
               
               ListTile(
                leading: Icon(Icons.auto_graph_sharp),
                title: Text('Analytics'),
              ),
               ListTile(
                leading: Icon(Icons.history),
                title: Text('View History'),
              ),
               ListTile(
                leading: Icon(Icons.add_alert_sharp),
                title: Text('Alerts'),
                 onTap:   () {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Alerts()));
        }
              ),
               ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
              ),
            ]        
              
              
              
              

              

              

              
        )
            
          ),
      )
        
    ;
  }
}

class Scanning {
}
