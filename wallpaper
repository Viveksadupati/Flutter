import 'dart:html';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Add constructor with Key

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Responsive UI"), // Make Text const
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('web/assets/wallpaper.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: width < 600
                ? const Text(
                    "Mobile Screen",
                    style: TextStyle(fontSize: 25),
                  )
                : const Text(
                    "Large Screen",
                    style: TextStyle(fontSize: 25),
                  ),
          ),
        ),
      ),
    );
  }
}
