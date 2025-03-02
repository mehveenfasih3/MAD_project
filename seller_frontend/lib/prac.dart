import "package:flutter/material.dart";
import "package:selller/main.dart";
void main(){
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: "Flutter App",
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key,required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [Title(color: Color(13), child: Text("My first App"))],),
    );
  }
}