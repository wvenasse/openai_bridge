import 'package:flutter/material.dart';
import './routers/routers.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 

 const MyApp({Key? key}) : super(key: key);
// --disable-web-security --user-data-dir=
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      title: 'Openai Bridge',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        )
      ),      
      initialRoute: "/",       
      onGenerateRoute: onGenerateRoute,     
    );
  }
}
