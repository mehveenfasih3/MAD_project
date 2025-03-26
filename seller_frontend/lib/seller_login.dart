import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:selller/main.dart';
import 'package:selller/seller_registration.dart';
import 'package:http/http.dart'as http;


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name ="";
  bool changedButton = false;
  final _formkey = GlobalKey<FormState>();
   final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


moveToHome(BuildContext context)async{
   if(_formkey.currentState!.validate()){ 
      setState(() {
      changedButton = true;


      });
           final Map<String, String> data = {
        'email': usernameController.text,
        'password': passwordController.text,
      };

      // Send data to the backend
      try {
        final response = await http.post(
          Uri.parse('http://192.168.100.239:5000/api/seller_login'), // Replace with your backend URL
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          // Success
          
          print('Login successful');
          Future.delayed(Duration.zero, () {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Login successful"), backgroundColor: Colors.green),
            );
          }
        });

           await Future.delayed(Duration(seconds: 2));

          await Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (context)=> MyHomePage()));
        } else {
          // Error
          print('Login failed: ${response.body}');
           ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Enter Valid Credentials"), backgroundColor: Colors.red),
            );
          
         
        }
      } catch (e) {
        print('Error: $e');
       
      } finally {
        setState(() {
          changedButton = false;
        });
      }
    }
  }

     



  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Ensure a Scaffold is present
    body: SingleChildScrollView(
        child:Form(
          key:_formkey,
        child: Column(
          children: [
            Image.asset("assets/Icons/hey.png", fit: BoxFit.cover),
            const SizedBox(height: 20.0),
             Text(
              "Welcome $name",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              child: Column(
                children: [
                   TextFormField(
                    
                    decoration: const InputDecoration(
                      hintText: "Enter name",
                      labelText: "Name",
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Username can not be empty";
                      }
                      return null;
                    },
                    onChanged: (value){
                      name = value;
                      setState(() {});

                    },
                  ),
                  const SizedBox(height: 20.0),
           
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      hintText: "Enter email",
                      labelText: "Email",
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Email can not be empty";
                      }
                      return null;
                    },
                    
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Enter Password",
                      labelText: "Password",
                    ),
                     validator: (value){
                      if(value!.isEmpty){
                        return "Password can not be empty";
                      }
                      else if(value.length <5){
                        return "Password can not be less than 6 characters";
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20.0),
                  Row(
children: [
    Text("Not sign in?"),
    
    
    TextButton(onPressed: (){
      Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (context)=> CreateAccountScreenseller()));
    

    }, child: Text("sign up",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.blue),))

],

),
                Material(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(changedButton? 50: 8 ),
                  child:InkWell(
                  onTap:() => moveToHome(context),
                  // Navigator.pushReplacement(
// context,
// MaterialPageRoute(builder: (context)=>MyHomePage())),
    
                  child:AnimatedContainer(
                    duration: Duration(seconds: 1),
                    child:changedButton?Icon(Icons.done , color: Colors.white,):Text("Login",style:TextStyle(fontSize:20,fontWeight:FontWeight.bold,color: Colors.white)),
                    height: 50,
                    width: changedButton? 50:150,
                    
                    alignment:Alignment.center,
                  )
                  )
                ),
             
                ],
              )
              ,
            ),
          ],
        ),
      ),
      ),
    );
  }
}
