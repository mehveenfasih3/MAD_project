import 'package:flutter/material.dart';


class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
String getDiscountedPrice(double price, double discountPercentage) {
  double discountedPrice = price - (price * discountPercentage / 100);
  return discountedPrice.toStringAsFixed(2);
}



  @override
  Widget build(BuildContext context) {
  double tax;
  double total;
    
  List<dynamic> cartItems = ModalRoute.of(context)?.settings.arguments as List<dynamic>? ?? [];
  

  Map<String,double> calculateTotal() {
  double bill = cartItems.fold(0.0, (sum, item) => sum + (item.price - (item.price * item.discount / 100)),);
  tax=0.1*bill;
  total=bill+tax;
  Map<String,double> finalbill={"Tax":tax,"Total":total};
  return finalbill; // Returns the total as a formatted string
}

  
 
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor:  Color.fromARGB(255, 68, 10, 228),
      ),
      
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // List of selected products
          Container(alignment: Alignment.bottomRight,child: ElevatedButton(onPressed:(){setState(() {
            cartItems.clear();
          });} ,child: Text("Remove All"),style: ButtonStyle(),),),
            Expanded(
              child: cartItems.isEmpty
          ? Center(child: Text('No items in the cart'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
  var product = cartItems[index];  // CartItem object
  return ListTile(
    leading: Image.network(product.imageUrl, height: 20, width: 20),  // Access imageUrl from the CartItem
    title: Text(product.title),  // Access title from the CartItem
    // subtitle: Text('Price: ${product.price}Rs'),  // Access price from the CartItem
    subtitle: Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Price: ',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: '${product.price}Rs  ',
        style: TextStyle(
          color: Colors.red,
          decoration: TextDecoration.lineThrough, // strike-through
        ),
      ),
      TextSpan(
        text: '${getDiscountedPrice(product.price, product.discount)}Rs',
        style: TextStyle(color: Colors.green),
      ),
    ],
  ),
),
  );
},

              ),
            ),

            // Subtotal, Shipping Cost, Tax, Total
            Divider(),
            ListTile(
              title: Text('Tax (10%)'),
              trailing: Text('${calculateTotal()['Tax']}Rs', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
           
          
            Divider(),
            ListTile(
              title: Text('Total'),
              trailing: Text('${calculateTotal()['Total']}Rs', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20),

            // Checkout button
            ElevatedButton(
              onPressed: () {
                // Create a map with total and cartItems
    Map<String, dynamic> arguments = {
      "total": calculateTotal()["Total"],
      "cartItems": cartItems,

    };

    // Push to the payment page with the arguments
    Navigator.pushNamed(
      context,
      '/payment',
      arguments: arguments,  // Passing the map containing both values
    );
               
              },
              child: Text('Checkout',style: TextStyle(fontWeight: FontWeight.bold,
              color: Colors.white
              )
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color.fromARGB(255, 68, 10, 228) // Full-width button
              ),
            ),
          ],
        ),
      ),
    );
  }
}