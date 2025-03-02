import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:selller/main.dart';
import 'package:selller/prac.dart';

class additem extends StatefulWidget {
  const additem({super.key});

  @override
  State<additem> createState() => _additemState();
}

class _additemState extends State<additem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        
      
       
        children: [
          Container(
            
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Add Item',textAlign: TextAlign.center,
            style:  GoogleFonts.aBeeZee(textStyle:TextStyle(fontSize: 40,fontWeight: FontWeight.w900),),
             ),
              SizedBox(width: 10,),
          Icon(Icons.add,size: 35,weight: 56,)
          ]
          ),
          
          ),
          SizedBox(height: 10,),
          Container(
            child: Column(
              children: [
                 TextField(
                          //controller: "dww",
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: 'Item name',
                            hintText: "Enter Item name",
                            focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2.0),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2.0),
  ),
                            border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),filled: true,
  fillColor: Colors.grey[200],
                          ),
                        ),
                        SizedBox(height: 10),
                         TextField(
                          //controller: nameController,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            hintText: "Enter Price",border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    
  ),
focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2.0),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2.0),
  ),filled: true,
  fillColor: Colors.grey[200],
                          ),
                        ),
                        SizedBox(height: 10),
                         TextField(
                          //controller: nameController,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: "Description",
                            hintText: 'Enter Description of item',
                            border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2.0),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2.0),
  ), contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
  filled: true,
  fillColor: Colors.grey[200],
 
                          ),
                        ),
                        SizedBox(height: 10),
                         TextField(
                          //controller: nameController,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: "Expiry Date",
                            hintText: 'Enter Expiry Date',
                            border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2.0),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2.0),
  ),
   contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
  filled: true,
  fillColor: Colors.grey[200],
 ),
                        ),
                        SizedBox(height: 10),
                         TextField(
                          //controller: nameController,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            hintText: "Enter Number of items in a box",
                            border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2.0),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2.0),
  ),
   contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
  filled: true,
  fillColor: Colors.grey[200],
 
                            
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          //controller: nameController,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: 'Item Description',
                            hintText: "Enter Item Description",
                            border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2.0),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2.0),
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
  filled: true,
  fillColor: Colors.grey[200],
                          ),
                        ),
                        SizedBox(height: 15,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                ();
                                 Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> MyHomePage()));
                              
                              },
                              child: Text("Add Now!",style: TextStyle(color: Colors.black),),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF8E6CEF),
                              ),
                            ),
                          ],
                        ),
                       
                        
              ],
            ),
          ),
          
         
        ],
      ),  
    
    
        
      );
    
  }
}