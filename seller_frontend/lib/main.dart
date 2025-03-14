import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:selller/SplashScreen.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:selller/additem.dart';
import 'package:selller/alerts.dart';
import 'package:selller/prac.dart';

import 'package:http/http.dart'as http;

import 'package:image_picker/image_picker.dart';
//import 'package:file_picker/file_picker.dart';


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
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


 

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
File? _selectedimage;
  
Future getimagefromcamera() async {
  final returnedimage = await ImagePicker().pickImage(source: ImageSource.camera);

  if (returnedimage != null) {
    setState(() {
      _selectedimage = File(returnedimage.path);
    });
  } else {
    print("No image selected");
  }
}


Future getimagefromgallery() async {
  
  final returnedimage = await ImagePicker().pickImage(source: ImageSource.gallery);
print(returnedimage);
  if (returnedimage != null) {
    setState(() {
      _selectedimage = File(returnedimage.path);
    });
  } else {
    print("No image selected");
  }
}
Future<void> sendBarcodeDataToFlask(File? selectedImage) async {
  const String baseUrl = "http://192.168.100.239:5000";

  try {
    var request = http.MultipartRequest("POST", Uri.parse('$baseUrl/add_barcode'));

   
    if (selectedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', 
          selectedImage.path,
          
        ),
      );
    }

   
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print("Barcode added successfully: ${response.body}");
    } else {
      print("Error: ${response.body}");
    }
  } catch (e) {
    print("Exception: $e");
  }
}

 @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          
          
          title: Text('Smart Supply',style:  TextStyle(fontSize: 24,fontWeight: FontWeight.w900)
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
           
           Text('Scan Your Item',style:  TextStyle(fontSize: 24,fontStyle: FontStyle.normal,fontWeight: FontWeight.w900),
           ),
           Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
            color: Colors.white, 
  border: Border.all(
    color: Colors.grey, 
    width: 1.0, 
  ),
  borderRadius: BorderRadius.circular(12.0), 

  
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1), 
      spreadRadius: 2, 
      blurRadius: 8, 
      offset: Offset(4, 4), 
    ),
  ],
            ),
            
            
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
               height: 250,
            width: 300,
            child:Center(
              child:  _selectedimage != null? Image.file(_selectedimage!):const Text("Please scan your barcode",textAlign:TextAlign.center,),
              
            )
              )
            ],
          
                 ),
           ),
            
SizedBox(height: 10,),
Row(
  mainAxisAlignment:MainAxisAlignment.center,
  children: [
        
IconButton(onPressed: (
  
){
  getimagefromgallery();
}, icon: Icon(Icons.photo,color: const Color.fromARGB(255, 69, 75, 72),),
iconSize: 30,),
SizedBox(width: 10,),
IconButton(onPressed: (
  
){
  getimagefromcamera();
}, icon: Icon(Icons.camera_alt,color: const Color.fromARGB(255, 69, 75, 72),),
iconSize: 30,),
  ]),
           ElevatedButton(
                              onPressed: () {
                                sendBarcodeDataToFlask(_selectedimage);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> additem()));
                              },
                              child: Text("Scan Now!",style: TextStyle(color: Colors.black),),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF8E6CEF),
                              ),
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
                    // backgroundImage: AssetImage('assets/avatar_placeholder.png'), 
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

