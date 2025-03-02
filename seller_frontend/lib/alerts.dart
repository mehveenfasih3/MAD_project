import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Alerts extends StatefulWidget {
  const Alerts({super.key});

  @override
  State<Alerts> createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
   final List<Map<String, dynamic>> productList = [
    {
      'name': 'Product A',
      'expiryDate': '2025-03-10',
      'daysLeft': 25,
      'price': 120.0,
    },
    {
      'name': 'Product B',
      'expiryDate': '2025-04-15',
      'daysLeft': 60,
      'price': 150.0,
    },
    {
      'name': 'Product C',
      'expiryDate': '2025-02-28',
      'daysLeft': 10,
      'price': 80.0,
    },
    {
      'name': 'Product D',
      'expiryDate': '2025-05-01',
      'daysLeft': 75,
      'price': 200.0,
    },
     {
      'name': 'Product E',
      'expiryDate': '2025-05-01',
      'daysLeft': 75,
      'price': 700.0,
    },
  ];
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      
      body:  ListView.builder(
        
        itemCount: productList.length,
        itemBuilder: (context, index) {
          final product = productList[index];
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
            style:  GoogleFonts.aBeeZee(textStyle:TextStyle(fontSize: 30,fontWeight: FontWeight.w900,color: Colors.red),),
             ),
              SizedBox(width: 10,),
          Icon(Icons.alarm,size: 30,weight: 56,color: Colors.red,),
                   ]
                  ),
          
          
          
                  Text(
                    'Product Name: ${product['name']}',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Text('Expiry Date: ${product['expiryDate']}'),
                  Text('Days Left: ${product['daysLeft']} days'),
                  Text(
                    'Price: \$${product['price'].toStringAsFixed(2)}',
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
