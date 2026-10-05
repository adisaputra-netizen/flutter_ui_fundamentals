import 'package:flutter/material.dart';

// Identitas Mahasiswa
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
      title: 'Course Explorer - Tahap 14',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const FeedbackScreen(),
    );
  }
}

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  
  bool _isLoading = false;
  String _statusMessage = 'Belum ada data yang dikirim';

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // 1. Fungsi menampilkan Dialog Konfirmasi
  Future<void> _confirmAndSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final bool? shouldProceed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi Pengiriman'),
          content: Text(
            'Apakah Anda yakin ingin mengirim ulasan untuk mahasiswa $studentName ($studentId)?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );

    if (shouldProceed == true) {
      _processData();
    }
  }

  // 2. Fungsi Simulasi Loading dan SnackBar
  Future<void> _processData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulasi delay asynchronous 2 detik
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _statusMessage = 'Ulasan tersimpan: "${_commentController.text}"';
      _commentController.clear();
    });

    // Tampilkan SnackBar feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Feedback berhasil dikirim dan dicatat!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback & Dialog'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Praktikan: $studentName',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text('NIM: $studentId'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Komentar Course',
                  hintText: 'Tuliskan evaluasi Anda...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.rate_review_outlined),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Komentar tidak boleh kosong';
                  }
                  if (val.trim().length < 5) {
                    return 'Minimal 5 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Tombol atau Loading Indicator
              _isLoading
                  ? const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text('Menyimpan data...'),
                        ],
                      ),
                    )
                  : FilledButton.icon(
                      onPressed: _confirmAndSubmit,
                      icon: const Icon(Icons.send),
                      label: const Text('Simpan Feedback'),
                    ),
              const SizedBox(height: 24),
              const Divider(),
              Text(
                'Status: $_statusMessage',
                style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}