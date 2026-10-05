import 'package:flutter/material.dart';

// Identitas Mahasiswa (Wajib muncul di UI dan Kode)
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
      title: 'Tahap 6 - Scrollable Content & Keyboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const ScrollableFormPage(),
    );
  }
}

class ScrollableFormPage extends StatefulWidget {
  const ScrollableFormPage({super.key});

  @override
  State<ScrollableFormPage> createState() => _ScrollableFormPageState();
}

class _ScrollableFormPageState extends State<ScrollableFormPage> {
  bool _useScroll = true; // Switch untuk menguji dengan atau tanpa SingleChildScrollView

  @override
  Widget build(BuildContext context) {
    // Konten formulir panjang yang melebihi tinggi layar saat keyboard muncul
    Widget formContent = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Identitas
          Card(
            color: Colors.blueGrey.shade50,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tahap 6: Scrollable & Keyboard Handling',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('$studentId - $studentName',
                      style: const TextStyle(fontSize: 13, color: Colors.blueGrey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Tombol Sakelar untuk demonstrasi
          SwitchListTile(
            title: const Text('Gunakan SingleChildScrollView', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(_useScroll ? 'Aktif: Bebas overflow keyboard' : 'Nonaktif: Rentan overflow keyboard'),
            value: _useScroll,
            onChanged: (val) => setState(() => _useScroll = val),
          ),
          const Divider(),

          // Field-field input
          const Text('Field 1: Informasi Akademik', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Program Studi',
              hintText: 'Pendidikan Teknik Informatika',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          const Text('Field 2: Nama Mata Kuliah', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Mata Kuliah',
              hintText: 'Pemrograman Mobile',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          const Text('Field 3: Masukan / Catatan', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Komentar Pembelajaran',
              hintText: 'Tuliskan catatan di sini...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          // Field bagian bawah yang akan tertutup keyboard
          const Text('Field 4: Target Nilai (Posisi Bawah)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Target Grade',
              hintText: 'A',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Simpan Data Formulir'),
            onPressed: () {
              FocusScope.of(context).unfocus(); // Menutup keyboard
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Formulir berhasil disimpan!')),
              );
            },
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 6 - Scrollable Content'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      // Kondisi pengujian: dibungkus SingleChildScrollView atau Column polos
      body: _useScroll ? SingleChildScrollView(child: formContent) : formContent,
    );
  }
}