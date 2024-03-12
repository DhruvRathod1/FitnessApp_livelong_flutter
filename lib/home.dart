import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key, required this.title}) : super(key: key); // Add 'required this.title' parameter

  final String title; // Define the title parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), // Use the 'title' parameter here
      ),
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}
