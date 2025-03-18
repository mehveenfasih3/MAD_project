import 'package:flutter/material.dart';
import 'package:selller/SplashScreen.dart';
import 'package:selller/seller_login.dart';



class CreateAccountScreenseller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (context)=> LoginPage()));
    
                },
              ),
              SizedBox(height: 10),

              // Title
              Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              // Input Fields
              _buildInputField("Enter Factory Name","Factory Name"),
              _buildInputField("Enter Email Address","Email Address"),
              _buildInputField("Enter Phone Number","Phone Number"),
              _buildInputField("Enter Password","Password", obscureText: true),
              _buildInputField("Enter Factory Address","Factory Address"),
              _buildInputField("Enter Account Number","Account Number"),

              SizedBox(height: 30),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle form submission
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9B70F1), // Light purple button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  
                  child: Text(
                    "Sign up",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),onLongPress: () {
                  Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (context)=> LoginPage()));
    
                },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to create a text input field
  Widget _buildInputField(String hint,String mylabel, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          labelText: mylabel,
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey), // Hint text size
          labelStyle: TextStyle(fontSize: 16),
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
