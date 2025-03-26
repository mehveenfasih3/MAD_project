
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:selller/main.dart';
import 'dart:convert';

import 'package:selller/seller_login.dart';

class CreateAccountScreenseller extends StatelessWidget {
  // Controllers for text fields
  final TextEditingController factoryNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();

  Future<void> _submitForm(BuildContext context) async {
    // Collect data from text fields
    final Map<String, String> data = {
      'factory_name': factoryNameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'password': passwordController.text,
      'factory_address': addressController.text,
      'account_number': accountNumberController.text,
    };

    // Send data to the backend
    final response = await http.post(
      Uri.parse('http://192.168.100.239:5000/api/signup'), // Replace with your backend URL
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    // Handle response
    if (response.statusCode == 200) {
      // Success
      print('Signup successful');
       ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Account has been Created"), backgroundColor: Colors.green),
            );
          
      
    } else {
      // Error
      print('Signup failed: ${response.body}');
       ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to create your Account"), backgroundColor: Colors.red),
            );
          
    }
     
                 
  }

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
              _buildInputField("Enter Factory Name", "Factory Name", controller: factoryNameController),
              _buildInputField("Enter Email Address", "Email Address", controller: emailController),
              _buildInputField("Enter Phone Number", "Phone Number", controller: phoneController),
              _buildInputField("Enter Password", "Password", obscureText: true, controller: passwordController),
              _buildInputField("Enter Factory Address", "Factory Address", controller: addressController),
              _buildInputField("Enter Account Number", "Account Number", controller: accountNumberController),

              SizedBox(height: 30),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton (
                  onPressed: ()async{ 
                   await  _submitForm(context);
                   Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>LoginPage()));
                    
                     

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9B70F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Create Account",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                
              ),
              )
            ]
          ),
        ),
      ),
    );
  }

  // Widget to create a text input field
  Widget _buildInputField(String hint, String mylabel, {bool obscureText = false, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          labelText: mylabel,
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
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