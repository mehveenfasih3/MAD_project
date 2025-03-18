import 'package:flutter/material.dart';
import 'package:selller/additem.dart';
import 'package:selller/alerts.dart';


import 'package:http/http.dart'as http;

import 'package:image_picker/image_picker.dart';
import 'package:selller/drawer.dart';
import 'package:selller/graphs.dart';
import 'package:selller/seller_order.dart';
import 'package:selller/seller_product.dart';
//import 'package:file_picker/file_picker.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return  Drawer(
          
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
              ),
            ]        
              
              
              
              

              

              

              
        )
            
          );
    
  }
}