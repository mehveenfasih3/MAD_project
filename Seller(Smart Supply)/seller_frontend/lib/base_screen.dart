import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:selller/drawer.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final String title;

  const BaseScreen({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 24,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w900,
            
          ),
        ),
        backgroundColor: const Color(0xFF8E6CEF),
      ),
      
      drawer: CustomDrawer(),
    );
  }
}