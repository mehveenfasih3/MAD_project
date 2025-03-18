import 'package:flutter/material.dart';
import 'package:selller/drawer.dart';

//import 'package:go_router/go_router.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // /final orderId = GoRouterState.of(context).pathParameters['id'];

    return Scaffold(
      appBar: AppBar(
          
          
          title: Text('Smart Supply',style:  TextStyle(fontSize: 24,fontWeight: FontWeight.w900)
        ),
       
        backgroundColor: Color(0xFF8E6CEF),
      ),
      drawer: CustomDrawer(),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Order ${index + 1}',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 142, 108, 239),
                          
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.receipt, size: 30, color: Color.fromARGB(255, 142, 108, 239)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Retailer Email: ${order['retailerEmail']}',
                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Order ID: ${order['id']}'),
                  Text('Products: ${order['products'].join(', ')}'),
                  Text(
                    'Total Price: \$${order['totalPrice'].toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Order Date: ${order['orderDate']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  final List<Map<String, dynamic>> orders = [
    {
      'id': '#456765',
      'retailerEmail': 'retailer1@example.com',
      'products': ['Mango', 'Apple', 'Guava'],
      'totalPrice': 120.50,
      'orderDate': '2025-03-10 14:30',
    },
    {
      'id': '#454569',
      'retailerEmail': 'retailer2@example.com',
      'products': ['Dragon Fruit', 'Grapes'],
      'totalPrice': 299.99,
      'orderDate': '2025-03-11 10:15',
    },
    {
      'id': '#454809',
      'retailerEmail': 'retailer3@example.com',
      'products': ['Watermelon'],
      'totalPrice': 799.00,
      'orderDate': '2025-03-12 18:45',
    },
  ];
}