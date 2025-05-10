import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:selller/additem.dart';
import 'package:selller/alerts.dart';


import 'package:http/http.dart'as http;

import 'package:image_picker/image_picker.dart';
import 'package:selller/baseurl.dart';
import 'package:selller/drawer.dart';
import 'package:selller/graphs.dart';
import 'package:selller/main.dart';
import 'package:selller/seller_login.dart';
import 'package:selller/seller_order.dart';
import 'package:selller/seller_product.dart';
//import 'package:file_picker/file_picker.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // static const String baseUrl = "http://192.168.100.239:5000";
  List<Map<String, dynamic>> sellers = []; 
   @override
  void initState() {
    super.initState();
    get_sellers_information(); 
  }
  Future<void> get_sellers_information() async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/get_sellers_information'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
print(data);
        setState(() {
          sellers= List<Map<String, dynamic>>.from(data['data']);
          
        });
      } else {
        print("Error: ${response.body}");
       
      }
    } catch (e) {
      print("Exception: $e");
      
    }
     print(sellers);
  }
 
  @override
  Widget build(BuildContext context) {
    
    return  Drawer(
          
          child: ListView(
            children:[
                 DrawerHeader(
        decoration: const BoxDecoration(color: Color(0xFF8E6CEF)),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sellers.map<Widget>((seller) => Padding(
            padding: const EdgeInsets.only(bottom: 10), 
            child: Row(
              children: [
               
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color.fromARGB(255, 208, 136, 221),
                  child: Center(
                    child: Text(
                      seller['SellerName'][0].toString().toUpperCase(), // First letter of seller name
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seller['SellerName'],
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      seller['SellerEmail'],maxLines: 1,softWrap: true,overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),

                    ),
                  ],
                ),
              ],
            ),
          )).toList(),
        ),
      ),
           
              ListTile(
                leading: Icon(Icons.scanner),
                title: Text('Scan Items'),
                onTap:   () {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
        }),    
               ListTile(
                leading: Icon(Icons.smart_display),
                title: Text('Your Products'),
                onTap:   () {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ShoppingScreen()));
        }
              ),
               
               ListTile(
                leading: Icon(Icons.auto_graph_sharp),
                title: Text('Analytics'),
                 onTap:   () {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SalesGraphScreen()));
        }
        ),    
                
              
               ListTile(
                leading: Icon(Icons.history),
                title: Text('View History'),
                onTap:   () {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => OrdersScreen()));
        }
              
             
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
                 onTap:   () {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
              ),
            ]        
              
              
              
              

              

              

              
        )
    
          );
    
  }
}