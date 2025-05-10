import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:selller/baseurl.dart';
import 'package:selller/drawer.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<List<dynamic>> orders;

  Future<List<dynamic>> getOrderHistory() async {
    try {
      final res = await http.get(Uri.parse("${ApiConstants.baseUrl}/get_orders"));
      print("Response Code: ${res.statusCode}");
      print("Response Body: ${res.body}");

      if (res.statusCode != 200) {
        throw "Failed to fetch data";
      }

      final data = jsonDecode(res.body);
      return data;
    } catch (err) {
      print("Error fetching order history: $err");
      throw Exception("Error fetching order history: $err");
    }
  }

  @override
  void initState() {
    super.initState();
    orders = getOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order History",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        backgroundColor: const Color(0xFF8E6CEF),
      ),
      drawer: CustomDrawer(),
      body: FutureBuilder<List<dynamic>>(
        future: orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders found"));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              print("Rendering Order ${index + 1}: ${data[index]}"); // Debugging UI issue
              final order = data[index];
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
                            style: const TextStyle(
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
                      Text('Retailer Email: ${order['RetailerEmail'] ?? "N/A"}'),
                      Text('Order ID: ${order['OrderId'] ?? "N/A"}'),
                      Text('Products: ${order['Products'] is List ? order['Products'].map((p) => p["ProductName"]).join(", ") : "No Products"}'),
                      Text(
                        'Total Price: \$${order['TotalPrice'] ?? "0.00"}',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Order Date: ${order['OrderDateTime'] ?? "Unknown"}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
