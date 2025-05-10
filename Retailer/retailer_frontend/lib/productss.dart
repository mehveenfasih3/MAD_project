import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For parsing the JSON response
import 'package:flutter_svg/flutter_svg.dart';
import 'package:retailer_frontend/baseurl.dart';
import 'package:retailer_frontend/main.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  // Create a TextEditingController to capture the user's input
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    // Don't forget to dispose the controller when done
    _searchController.dispose();
    super.dispose();
  }
  List<dynamic> filteredProducts = [];

  // This function will be triggered when the user types something
  void _onSearchChanged() {
    setState(() {
      // Filter the products based on the text input
      filteredProducts = products.where((product) {
        return product['ProductName']!.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }
  // This will hold the list of products fetched from the API
  List<dynamic> products = [];
  List <CartItem> cartItems=[];

 // Method to add item to cart
  void addToCart(CartItem item) {
    setState(() {
      // Add the item to the cart
      cartItems.add(item);

      // Optionally print the updated cart items
      print('Item added: ${cartItems[cartItems.length - 1].title}');
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item added to cart')),
);
    });
  }
  // Fetch products from the API
  Future<void> fetchProducts() async {
    print('***********HIII************************');
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/products'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      setState(() {
        products = json.decode(response.body);
        filteredProducts=products;
      });
    } else {
      // If the server returns an error
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products when the screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       'Smart Supply',
    //       style: TextStyle(
    //         fontSize: 24,
    //         fontStyle: FontStyle.italic,
    //         fontWeight: FontWeight.w900,
    //       ),
    //     ),
    //     backgroundColor: Color.fromARGB(255, 68, 10, 228),
    //     actions: [
    //         IconButton(
    //           icon: SvgPicture.asset(
    //             'assets/cart.svg', // Provide the path to your SVG file
    //             width: 24,  // Adjust the width as needed
    //             height: 24, // Adjust the height as needed
    //           ),
    //           onPressed: () {
    //             Navigator.pushNamed(
    //   context,
    //   '/cart',
    //   arguments: cartItems,  // Passing the cartItems list as arguments
    // );
    //           },
    //         ),
    //       ],
    //     ),
        
     

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
                  Row(children: [
 IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> MyHomePage()));
                              
                },
              ),
              SizedBox(width: 250,),
              IconButton(
                
              icon: SvgPicture.asset(
                'assets/cart.svg', // Provide the path to your SVG file
                width: 24,  // Adjust the width as needed
                height: 24, // Adjust the height as needed
              ),
              onPressed: () {
                Navigator.pushNamed(
      context,
      '/cart',
      arguments: cartItems,  // Passing the cartItems list as arguments
    );
              }),
                  ],),
                  
             
                  Row(
                    children: [
                      Expanded(
                        child: ProductSearch(),
                      ),
                    ],
                  ),
                  SizedBox(height: padding),

                  Text(
                    '${products.length} Results Found', // Dynamically show the number of products
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
                      itemCount: filteredProducts.length, // Use the length of the fetched products
                      itemBuilder: (context, index) {
                        var product = filteredProducts[index];
                        return ProductCard(
                          imageUrl: product['ProductImage'], // Assuming the URL is provided by the API
                          title: product['ProductName'],
                          price: double.parse(product['ProductPrice']),
                          description: product['ProductDescription'],
                          // discount: double.parse(product['ProductDiscount']),
                          type: product['ProductType'],
                          // quantity:double.parse( product['ProductQuantity']),
                              discount: (product['ProductDiscount'] is String) 
            ? double.parse(product['ProductDiscount']) 
            : (product['ProductDiscount'] as num).toDouble(),  // Handle int or double

quantity: (product['ProductQuantity'] is String) 
            ? double.parse(product['ProductQuantity']) 
            : (product['ProductQuantity'] as num).toDouble(),  // Handle int or double

                          onAddToCart: () {
                            //Add to cart logic
                            CartItem cartItem = CartItem(
                              productID: product['ProductId'],
                              imageUrl: product['ProductImage'],
                              title: product['ProductName'],
                              price: double.parse(product['ProductPrice']) - 
       (double.parse(product['ProductPrice']) * 
        double.parse(product['ProductDiscount']) / 100),
                              // price: double.parse(product['ProductPrice']-(product['ProductPrice']*product['ProductDiscount'])/100),
                              description: product['ProductDescription'],
                              
                            );
                            addToCart(cartItem);
                            

                          }
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

  TextField ProductSearch() {
    return TextField(
       controller: _searchController,  // Attach the controller
      onChanged: (value) {
        // Triggered every time the user types
        _onSearchChanged();
      },
      decoration: InputDecoration(
        hintText: 'Search for Products...',
        prefixIcon: const Icon(Icons.search),
         suffixIcon: _searchController.text.isNotEmpty
        ? IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _searchController.clear(); 
              setState(() {});  
            },
          )
        : null,
        // suffixIcon: const Icon(Icons.close),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final String description;
  final double discount;
   final String   type;
   
 final double   quantity;
                              
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.description,
    required this.onAddToCart,
    required this.type,
    required this.quantity,
    required this.discount,
    

  });

  @override
  Widget build(BuildContext context) {
    print(discount);
    return LayoutBuilder(
      builder: (context, constraints) {
        double fontSize = (constraints.maxWidth * 0.08).clamp(10.0, 16.0);
        return SizedBox(
  height: 2500, // Set a suitable height
  child: Card(
        
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  imageUrl,
                  height: constraints.maxHeight * 0.5,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                children: [
 Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1),
                child: Text(
                  ('${title},'),
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1),
                child: Text(
                  type ,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
                ],
              ),
             
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1),
                child: Text(
                  ('No of ${title}:${quantity.toString()}'),
                  style: TextStyle(
                    fontSize: 12,
                    
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: fontSize * 0.7,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${price.toStringAsFixed(2)}Rs',
                      style: TextStyle(
                        fontSize: fontSize * 1.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1),
                child: Text(
                  ('${discount.toString()}% Off'),
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: onAddToCart,
                      style: ElevatedButton.styleFrom(
                        // Color.fromARGB(255, 117, 174, 254)
                        
                                backgroundColor: Color.fromARGB(255, 68, 10, 228),
                              ),
                      
                       // Calls the callback
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          
                          Text("Add to Cart",style: TextStyle(color: Colors.white),),
                          Icon(Icons.shopping_cart, size: 20,color: Colors.white,),
                        ],
                        
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          )
        );
      },
    );
  }
}

class CartItem {
  final int productID;
  final String imageUrl;
  final String title;
  final double price;
  final String description;

  CartItem({
    required this.productID,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.description,
  });
}