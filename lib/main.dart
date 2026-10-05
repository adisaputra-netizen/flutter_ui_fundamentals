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
      title: 'Tahap 3 - LayoutBuilder & Breakpoint',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const BreakpointShellPage(),
    );
  }
}

class BreakpointShellPage extends StatelessWidget {
  const BreakpointShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 3 - LayoutBuilder'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Breakpoint Praktikum: Compact (<600), Medium (600-839), Expanded (>=840)
          if (constraints.maxWidth < 600) {
            return CompactLayout(maxWidth: constraints.maxWidth);
          } else if (constraints.maxWidth < 840) {
            return MediumLayout(maxWidth: constraints.maxWidth);
          } else {
            return ExpandedLayout(maxWidth: constraints.maxWidth);
          }
        },
      ),
    );
  }
}

// 1. COMPACT LAYOUT (< 600 px) -> 1 Kolom Vertikal, Tema Amber/Orange
class CompactLayout extends StatelessWidget {
  final double maxWidth;
  const CompactLayout({super.key, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber.shade50,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildIdentityHeader('Compact (< 600 px)', Colors.orange, maxWidth),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              color: Colors.amber.shade100,
              elevation: 2,
              child: const Center(
                child: ListTile(
                  leading: Icon(Icons.phone_android, size: 40, color: Colors.orange),
                  title: Text(
                    'Mode Tampilan Single Column (Phone)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Layout dirancang memanjang vertikal untuk kenyamanan layar kecil satu tangan.'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 2. MEDIUM LAYOUT (600 - 839 px) -> 2 Kolom Berdampingan, Tema Teal
class MediumLayout extends StatelessWidget {
  final double maxWidth;
  const MediumLayout({super.key, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal.shade50,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildIdentityHeader('Medium (600 - 839 px)', Colors.teal, maxWidth),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.teal.shade100,
                    elevation: 2,
                    child: const Center(
                      child: ListTile(
                        leading: Icon(Icons.tablet, size: 40, color: Colors.teal),
                        title: Text('Kolom 1 (Navigasi/Menu)', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Tampilan tablet portrait / small tablet.'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    color: Colors.teal.shade200,
                    elevation: 2,
                    child: const Center(
                      child: ListTile(
                        leading: Icon(Icons.dashboard, size: 40, color: Colors.teal),
                        title: Text('Kolom 2 (Konten Utama)', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Ruang yang lebih lebar memungkinkan 2 kolom aktif.'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 3. EXPANDED LAYOUT (>= 840 px) -> 3 Kolom Berdampingan, Tema Indigo/Blue
class ExpandedLayout extends StatelessWidget {
  final double maxWidth;
  const ExpandedLayout({super.key, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo.shade50,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildIdentityHeader('Expanded (>= 840 px)', Colors.indigo, maxWidth),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.indigo.shade100,
                    elevation: 2,
                    child: const Center(
                      child: ListTile(
                        leading: Icon(Icons.view_sidebar, size: 36, color: Colors.indigo),
                        title: Text('Side Panel', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Menu samping.'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Card(
                    color: Colors.indigo.shade200,
                    elevation: 2,
                    child: const Center(
                      child: ListTile(
                        leading: Icon(Icons.laptop, size: 40, color: Colors.indigo),
                        title: Text('Workspace Utama', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Tablet landscape / Laptop / Desktop.'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    color: Colors.indigo.shade100,
                    elevation: 2,
                    child: const Center(
                      child: ListTile(
                        leading: Icon(Icons.info_outline, size: 36, color: Colors.indigo),
                        title: Text('Info Panel', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Detail tambahan.'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Header Identitas Mahasiswa (Sudah dibungkus Expanded agar tidak RenderFlex overflow)
Widget _buildIdentityHeader(String category, MaterialColor colorTheme, double currentWidth) {
  return Card(
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$studentId - $studentName',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Constraint Width: ${currentWidth.toStringAsFixed(1)} dp',
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Chip(
            backgroundColor: colorTheme.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            label: Text(
              category,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: colorTheme.shade900,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}