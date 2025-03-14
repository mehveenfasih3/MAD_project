import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:selller/additem.dart';
import 'package:http/http.dart'as http;
// import 'package:google_fonts/google_fonts.dart';

class Alerts extends StatefulWidget {
 
  const Alerts({super.key});

  @override
  State<Alerts> createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
   static const String baseUrl = "http://192.168.100.239:5000";
  List<Map<String, dynamic>> products = []; 
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    fetchProducts(); 
  }
  

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_products'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
print(data);
        setState(() {
          products = List<Map<String, dynamic>>.from(data['data']);
          isLoading = false; 
        });
      } else {
        print("Error: ${response.body}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Exception: $e");
      setState(() => isLoading = false);
    }
     print(products);
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
                    // backgroundImage: AssetImage('assets/avatar_placeholder.png'), // Placeholder for profile pic
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
     body: isLoading
          ? Center(child: CircularProgressIndicator()) 
          : products.isEmpty
              ? Center(child: Text("No products found")) 
              : ListView.builder(
      
        
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                   children: [
                    Text('Alert ${index + 1}',textAlign: TextAlign.center,
            //style:  GoogleFonts.aBeeZee(textStyle:TextStyle(fontSize: 30,fontWeight: FontWeight.w900,color: Colors.red),),
             ),
              SizedBox(width: 10,),
          Icon(Icons.alarm,size: 30,weight: 56,color: Colors.red,),
                   ]
                  ),
          
          
          Row(
            children: [Text(
                    'Product Name :'), 
                  Text(
                    ' ${product['ProductName']},',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10,),
                  Text('${product['ProductType']}',style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
            ]),
                  SizedBox(height: 4.0),
                  Text('Expiry Date: ${(product['FormattedExpiryDate'])}'),
                   Row(children: [
                    Text('Days Left :'),
                    SizedBox(width: 10,),
                     Text('${product['Days']} days',style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 180, 18, 6)),
               ),
                  ],),
                 
                  Text(
                    'Price: ${product['ProductPrice']} Rs',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          );
  })
     );
  }
  
   
       
    
    
        
      
  }
