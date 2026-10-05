import 'package:flutter/material.dart';

const String studentName = 'Kadek Adi Saputra';
const String studentId = '2415051005';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tahap 1 - Hard-coded Layout'),
        ),
        body: Row(
          children: [
            Container(
              width: 500, // Ukuran melebihi lebar 412px, memicu overflow
              color: Colors.amber.shade300,
              padding: const EdgeInsets.all(16),
              child: const Text(
                '2415051005 - Kadek Adi Saputra - Layout Hard-Coded dengan teks yang sangat panjang melebihi kapasitas layar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ), // Penutup Row
      ), // Penutup Scaffold
    ); // Penutup MaterialApp
  }
}