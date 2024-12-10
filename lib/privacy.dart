import 'package:flutter/material.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 52, 74, 135),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: ListView(
            children: [
              Container(
                child: const Text(' '),
              ),
              Container(
                child: const Text('\nInformation Collection and Us',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Container(
                child: const Text('\n'),
              ),
              Container(
                child: const Text('Cookies',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Container(
                child: const Text(''),
              ),
              Container(
                child: const Text(''),
              ),
              Container(
                child: const Text(''),
              ),
              Container(
                child: const Text(''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
