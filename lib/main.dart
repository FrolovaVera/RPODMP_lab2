import 'package:flutter/material.dart';
import 'package:lab2/screens/home_screen.dart';
void main() {
  runApp(HomeScreen());
}

class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return HomeScreenRSS();
  }
}