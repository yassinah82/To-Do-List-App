import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xff0140a28),
          leading: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          title: const Text(
            "Second Page",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Go Back'),
          ),
        ));
  }
}
