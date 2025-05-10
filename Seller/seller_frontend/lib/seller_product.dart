import 'package:flutter/material.dart';
import 'package:selller/baseurl.dart';
import 'package:selller/drawer.dart';

import 'package:selller/product_card.dart';
import "dart:convert";
import "package:http/http.dart" as http;

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  final Map<int, double> _discounts = {}; // Store discount per product ID
  late Future<List<dynamic>> products;
  TextEditingController searchcontroller=TextEditingController();
  Future<List<dynamic>> getOwnProducts() async {
    try {
      final res = await http
          .get(Uri.parse("${ApiConstants.baseUrl}/get_own_products"));
      print("Response Code: ${res.statusCode}");
      print("Response Body: ${res.body}");

      if (res.statusCode != 200) {
        throw "Failed to fetch data";
      }

      var data = jsonDecode(res.body);
   
 
      return data;
    } catch (err) {
      throw Exception("Error fetching product : $err");
    }
  }

  Future<void> updateDiscount(BuildContext context,int productId, double discountPercent) async {
    try {
      final res = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/update_discount/$productId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"ProductDiscount": discountPercent}), // Send as JSON object
      );

      if (res.statusCode != 200) {
         ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to update Discount"),backgroundColor: Colors.red,),
    );
        throw "Failed to update product";
        
      }

      print("Product updated successfully!");
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Discount Updated Successfully"),backgroundColor: Colors.green,),
    );
    } catch (err) {
      throw Exception("Error updating product: $err");
      
    }
  }
  
  
  

  @override
  void initState() {
    super.initState();
    products = getOwnProducts();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Smart Supply",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        backgroundColor: const Color(0xFF8E6CEF),
      ),
      drawer: CustomDrawer(),
      body: FutureBuilder<List<dynamic>>(
          future: products,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final data = snapshot.data!;
            final filteredData = searchcontroller.text.isNotEmpty
    ? data.where((item) => 
        item['ProductName'].toString().toLowerCase().contains(
            searchcontroller.text.toLowerCase()))
        .toList()
    : data;
    print('filtered data,${filteredData}');
           

            return SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double padding =
                      (constraints.maxWidth * 0.04).clamp(8.0, 20.0);
                  double fontSize =
                      (constraints.maxWidth * 0.04).clamp(12.0, 18.0);
                  int crossAxisCount =
                      (constraints.maxWidth / 200).floor().clamp(2, 4);

                  return Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: searchcontroller,
                                onChanged: (value) {
    setState(() {});  
  },
                                decoration: InputDecoration(
                                  hintText: 'Fruits',
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: searchcontroller.text.isNotEmpty
        ? IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              searchcontroller.clear(); 
              setState(() {});  
            },
          )
        : null,
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25.0)),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: padding),
                        Text(
                          '${data.length} Results Found',
                          style: TextStyle(
                              fontSize: fontSize * 1.2,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: padding),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio:
                                  (constraints.maxWidth / crossAxisCount) /
                                      (constraints.maxHeight * 0.5),
                              crossAxisSpacing: padding,
                              mainAxisSpacing: padding,
                            ),
                            
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              final product = filteredData[index];
                              final productId = product["ProductId"];

                              return ProductCard(
                                imageUrl: product["ProductImage"],
                                title: product["ProductName"],
                                price: double.parse(product["ProductPrice"]),
                                description: product["ProductDescription"],
                               type: product["ProductType"],
                                discount:
                                    double.tryParse(product["ProductDiscount"]) == 0.00
                                        ? _discounts[productId]
                                        : double.tryParse(product["ProductDiscount"]),
                                onAddDiscount: () =>
                                    _showDiscountModal(context, productId),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
    );
  }

 void _showDiscountModal(BuildContext context, int productId) {
    double discount = _discounts[productId] ?? 0.0;
    TextEditingController discountController =
        TextEditingController(text: discount.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add Discount',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: discountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Discount Percentage (%)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          double? newDiscount =
                              double.tryParse(discountController.text);
                          if (newDiscount != null &&
                              newDiscount > 0 &&
                              newDiscount <= 100) {
                            await updateDiscount(context,productId, newDiscount);
                            setState(() {
                              _discounts[productId] = newDiscount;
                              products =
                                  getOwnProducts();
                            });
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
 }}