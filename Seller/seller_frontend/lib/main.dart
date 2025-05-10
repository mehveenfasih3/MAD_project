import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:selller/SplashScreen.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:selller/additem.dart';
import 'package:selller/alerts.dart';


import 'package:http/http.dart'as http;

import 'package:image_picker/image_picker.dart';
import 'package:selller/baseurl.dart';
import 'package:selller/drawer.dart';
import 'package:selller/graphs.dart';
import 'package:selller/seller_order.dart';
import 'package:selller/seller_product.dart';
//import 'package:file_picker/file_picker.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
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
  // const String baseUrl = "http://192.168.100.239:5000";

  try {
    var request = http.MultipartRequest("POST", Uri.parse('${ApiConstants.baseUrl}/add_barcode'));

   
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
                              onPressed: () async{
                                await sendBarcodeDataToFlask(_selectedimage);
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

          
          
        
        drawer:CustomDrawer()
          )
        
    ;
  }
}

