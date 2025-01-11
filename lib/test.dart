import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0; // Initialize the counter

  void _incrementCounter() {
    setState(() {
      _count++; // Increment the counter
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Count: $_count', // Display the current count
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20), // Add some space
            ElevatedButton(
              onPressed: _incrementCounter, // Call increment function on press
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
