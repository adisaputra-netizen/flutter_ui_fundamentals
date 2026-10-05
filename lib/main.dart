import 'package:flutter/material.dart';

// Identitas Mahasiswa (Wajib)
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
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Tahap 13',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const FeedbackFormScreen(),
    );
  }
}

class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({super.key});

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  // GlobalKey untuk mengontrol dan memvalidasi Form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk field input
  late final TextEditingController _nameController;
  late final TextEditingController _idController;
  final TextEditingController _commentController = TextEditingController();

  String? _submittedData;

  @override
  void initState() {
    super.initState();
    // Nilai default diambil dari konstanta identitas
    _nameController = TextEditingController(text: studentName);
    _idController = TextEditingController(text: studentId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    // Validasi form dipanggil sebelum menampilkan hasil
    if (_formKey.currentState!.validate()) {
      setState(() {
        _submittedData =
            'Nama: ${_nameController.text}\nNIM: ${_idController.text}\nKomentar: ${_commentController.text}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form berhasil divalidasi dan disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form & Validasi Input'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Identitas Praktikan: $studentName - $studentId',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 16),
              // Field 1: Nama
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mahasiswa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Field 2: NIM
              TextFormField(
                controller: _idController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'NIM tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Field 3: Komentar (Minimal 5 Karakter)
              TextFormField(
                controller: _commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Komentar / Feedback Course',
                  hintText: 'Tuliskan ulasan minimal 5 karakter...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.chat_bubble_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Komentar wajib diisi';
                  }
                  if (value.trim().length < 5) {
                    return 'Komentar minimal 5 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _handleSubmit,
                icon: const Icon(Icons.send),
                label: const Text('Kirim Feedback'),
              ),
              const SizedBox(height: 24),
              // Menampilkan hasil setelah tervalidasi
              if (_submittedData != null)
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hasil Validasi Form:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(),
                        Text(_submittedData!),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}