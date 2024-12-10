import 'package:flutter/material.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 52, 74, 135),
        title: const Text(
          'About Us',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ListView(
          children: const [
            Text('',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
            SizedBox(height: 180),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  '',
                  style: TextStyle(
                      fontSize: 15, color: Color.fromARGB(255, 113, 113, 113)),
                )),
            SizedBox(height: 20),
          ],
        ),
      )),
    );
  }
}
