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
      title: 'Tahap 16 - Kasus D (SESUDAH)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const KasusDPage(),
    );
  }
}

class KasusDPage extends StatefulWidget {
  const KasusDPage({super.key});

  @override
  State<KasusDPage> createState() => _KasusDPageState();
}

class _KasusDPageState extends State<KasusDPage> {
  // ✅ FIX: Flag guard boolean untuk mengunci aksi ganda
  bool _isNavigating = false;

  void _safeNavigate() async {
    // 1. Jika sedang dalam proses navigasi, abaikan klik berikutnya
    if (_isNavigating) return;

    // 2. Kunci state navigasi dan update UI agar tombol nonaktif
    setState(() => _isNavigating = true);

    // 3. Jalankan navigasi dan tunggu (await) sampai halaman target ditutup/kembali
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text('Target Page (Safe Single Route)'),
            backgroundColor: Colors.green.shade100,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, size: 64, color: Colors.green),
                  const SizedBox(height: 16),
                  const Text(
                    'Halaman Berhasil Dibuka (Tepat 1 Route)!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('$studentId - $studentName'),
                  const SizedBox(height: 16),
                  const Text(
                    'Tekan Back sekali, dan kamu akan langsung kembali ke halaman awal tanpa ada halaman kembar yang menumpuk.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // 4. Buka kembali kunci guard saat sudah kembali ke halaman awal
    if (mounted) {
      setState(() => _isNavigating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasus D: Navigasi Ganda (SESUDAH)'),
        backgroundColor: Colors.green.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Identitas Mahasiswa
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: const Text(
                '$studentId - $studentName',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Kasus D: Navigasi dengan State Guard (FIXED)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coba tekan tombol di bawah berkali-kali secara cepat. Tombol akan langsung terkunci dan hanya membuka 1 rute:',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                // Jika _isNavigating true, passing null akan mendisable tombol secara otomatis
                onPressed: _isNavigating ? null : _safeNavigate,
                icon: _isNavigating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.verified_user),
                label: Text(
                  _isNavigating ? 'Sedang Membuka...' : 'Buka Halaman (Guarded)',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}