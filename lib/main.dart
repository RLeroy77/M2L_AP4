import 'package:flutter/material.dart';
// import 'package:ap4/Produits.dart';
import 'package:ap4/Connexion.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AP4"),
        centerTitle: true,
        backgroundColor: const Color(0xFFF6C614),
      ),
      body: const Connexion(),
      backgroundColor: const Color(0x00dbded0),
    );
  }
}
