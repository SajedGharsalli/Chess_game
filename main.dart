import 'package:flutter/material.dart';
import 'board.dart';
import 'upper screen.dart';
import 'lower screen.dart';

void main() {
  runApp(const MaterialApp(home: Home(),));}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            Expanded(child :Upper()),
            const Expanded(flex: 4, child: Board()),
            Expanded(child:Lower())
          ]
      ),
    );
  }
}
