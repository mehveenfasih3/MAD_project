import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String type;
  final double price;
  final double? discount;
  final String description;
  final VoidCallback onAddDiscount;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.type,
    required this.price,
    this.discount,
    required this.onAddDiscount,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    double discountedPrice =
        discount != null ? price * (1 - discount! / 100) : price;

    return LayoutBuilder(
      builder: (context, constraints) {
        double fontSize = (constraints.maxWidth * 0.08).clamp(10.0, 16.0);
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: constraints.maxHeight * 0.5,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: constraints.maxHeight * 0.5,
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.error)),
                      );
                    },
                  ),
                ),
              ),
              
                
 Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                child: Text(
                  title ,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
             
               Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                child: Text(
                  type ,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
                
            
             
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: fontSize * 0.8,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical:2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (discount != null && discount! > 0) ...[
                          Text(
                            '${price.toStringAsFixed(2)} Rs',
                            style: TextStyle(
                              fontSize: fontSize * 0.9,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                                overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${discountedPrice.toStringAsFixed(2)}Rs',
                            style: TextStyle(
                              fontSize: fontSize,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ] else
                          Text(
                            '${price.toStringAsFixed(2)}Rs',
                            style: TextStyle(
                              fontSize: fontSize * 1.1,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: onAddDiscount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Add Discount',
                      style: TextStyle(
                        fontSize: fontSize * 0.8,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}