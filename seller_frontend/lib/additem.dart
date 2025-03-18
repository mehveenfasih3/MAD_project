import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:selller/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart'as http;

class additem extends StatefulWidget {
  const additem({super.key});

  @override
  State<additem> createState() => _additemState();
}

class _additemState extends State<additem> {
  File? _selectedimage;
  static const String baseUrl = "http://192.168.100.239:5000";
  dynamic expirydate;
 
  
  TextEditingController ProductName = TextEditingController();
  TextEditingController ProductType = TextEditingController();
  TextEditingController ProductQuantity = TextEditingController();
  TextEditingController ProductPrice = TextEditingController();
  TextEditingController ProductDescription = TextEditingController();
  TextEditingController ProductExpiryDate = TextEditingController();
   @override
  void initState() {
    super.initState();
    fetchexpiry();
  }
  
   Future<void> sendDataToFlask() async {
     const String baseUrl = "http://192.168.100.239:5000";
    // try {
      
    //   final response = await http.post(
    //     Uri.parse('$baseUrl/add_product'),
    //     headers: {"Content-Type": "application/json"},
    //     body: json.encode({
    //       "ProductName": ProductName.text,
    //       "ProductType": ProductType.text,
    //       "ProductQuantity": ProductQuantity.text,
    //       "ProductPrice": ProductPrice.text,
    //       "ProductDescription": ProductDescription.text,
    //       "ProductExpiryDate": ProductExpiryDate.text,
    //       "ProductImage": _selectedimage?.path,
    //     }),
    //   );
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/add_product'));

  // Add other fields
    request.fields['ProductName'] = ProductName.text;
    request.fields['ProductType'] = ProductType.text;
    request.fields['ProductQuantity'] = ProductQuantity.text;
    request.fields['ProductPrice'] = ProductPrice.text;
    request.fields['ProductDescription'] = ProductDescription.text;
    request.fields['ProductExpiryDate'] = ProductExpiryDate.text;

    // Attach image file
    if (_selectedimage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'ProductImage',  // This must match the key Flask expects
        _selectedimage!.path,
      ));
    }

  var response = await request.send();
  
      if (response.statusCode == 200) {
        print("Product added successfully: ");
      } else {
        print("Error: ");
      }
    // } catch (e) {
    //   print("Exception: $e");
    // }
  }
  Future<void> fetchexpiry() async {
    
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_expiry'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
print(data);
        setState(() {
          expirydate = data['expiry_date'];
          print("expiry date");
          print(expirydate);
        });
      } else {
        print("Error: ${response.body}");
        
      }
    } catch (e) {
      print("Exception: $e");
     
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        
      
       
        children: [
          Container(
            color: Color(0xFF8E6CEF),
            
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              

          children: [
            
           
            Text('Add Item',textAlign: TextAlign.center,
           style:  TextStyle(fontSize: 40,fontWeight: FontWeight.w900),
             ),
              SizedBox(width: 10,),
          Icon(Icons.store,size: 35,weight: 56,)
          ]
          ),
          
          ),
          SizedBox(height: 10,),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.all(5)),
                
                 Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                     color: Colors.grey[200],
                    border: Border.all(
    color: Colors.grey, 
    width: 1.0, 
  ),
  borderRadius: BorderRadius.circular(150.0), 
boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1), 
      spreadRadius: 2, 
      blurRadius: 8, 
      offset: Offset(4, 4), 
    ),
  ],
            ),
            
      
                  
                   child:Center(
                    
              child:  _selectedimage != null? Image.file(_selectedimage!):const Text("Upload Product Image",textAlign:TextAlign.center,),
              
            )
              ),IconButton(onPressed: (
  
){
  getimagefromgallery();
}, icon: Icon(Icons.photo,color: const Color.fromARGB(255, 69, 75, 72),),
iconSize: 30,),
                 TextField(
                  cursorWidth: 3,

                          //controller: "dww",
                          textAlign: TextAlign.left,
                          controller: ProductName,
                          decoration: InputDecoration(
                            labelText: 'Product name',
                            hintText: "Please Enter Product name",
                            

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
                          controller: ProductType,
                          decoration: InputDecoration(
                            labelText: "Type",
                            hintText: 'Enter Type of Product',
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
                          controller: ProductPrice,
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
                          
                          controller: ProductExpiryDate,
                          
                          decoration: InputDecoration(
                            labelText: "Expiry Date",
                            hintText: 'Enter Expiry Date',
                            helperText: 'Hint: ${expirydate}',
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
                          controller: ProductQuantity,
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
                          controller: ProductDescription,
                          decoration: InputDecoration(
                            labelText: 'Product Description',
                            hintText: "Please Enter Product Description",
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
                              onPressed: (){
                                sendDataToFlask();
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
          
         
        ],
      ),  
    
    
        
      );
    
  }
}