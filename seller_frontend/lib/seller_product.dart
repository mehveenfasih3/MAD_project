import 'package:flutter/material.dart';
import 'package:selller/drawer.dart';
import 'package:selller/product_card.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  final Map<int, double> _discounts = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          
          
          title: Text('Smart Supply',style:  TextStyle(fontSize: 24,fontWeight: FontWeight.w900)
        ),
        
        backgroundColor: Color(0xFF8E6CEF),
        ),
      drawer: CustomDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double padding = (constraints.maxWidth * 0.04).clamp(8.0, 20.0);
            double fontSize = (constraints.maxWidth * 0.04).clamp(12.0, 18.0);
            int crossAxisCount = (constraints.maxWidth / 200).floor().clamp(2, 4);

            return Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Fruits',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: const Icon(Icons.close),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
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
                    '53 Results Found',
                    style: TextStyle(
                      fontSize: fontSize * 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: padding),

                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: (constraints.maxWidth / crossAxisCount) /
                            (constraints.maxHeight * 0.5),
                        crossAxisSpacing: padding,
                        mainAxisSpacing: padding,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          imageUrl: 'https://via.placeholder.com/150',
                          title: _getProductTitle(index),
                          price: _getProductPrice(index),
                          description: "Ok",
                          discount: _discounts[index],
                          onAddDiscount: () => _showDiscountModal(context, index),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _getProductTitle(int index) {
    switch (index) {
      case 0:
        return 'Club Fleece Mens Jacket';
      case 1:
        return 'Skate Jacket';
      case 2:
        return 'Therma Fit Puffer Jacket';
      case 3:
        return 'Men\'s Workwear Jacket';
      default:
        return 'Product';
    }
  }

  double _getProductPrice(int index) {
    switch (index) {
      case 0:
        return 56.97;
      case 1:
        return 150.97;
      case 2:
        return 280.97;
      case 3:
        return 128.97;
      default:
        return 0.00;
    }
  }

  void _showDiscountModal(BuildContext context, int index) {
    double discount = _discounts[index] ?? 0.0;
    TextEditingController discountController = TextEditingController(text: discount.toString());

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
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          double? newDiscount = double.tryParse(discountController.text);
                          if (newDiscount != null && newDiscount >= 0 && newDiscount <= 100) {
                            setState(() {
                              _discounts[index] = newDiscount;
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
  }
}