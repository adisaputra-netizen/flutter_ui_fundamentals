import 'package:flutter/material.dart';
import '../models/course_item.dart';

class CourseDetailScreen extends StatefulWidget {
  final CourseItem course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  bool _isLoading = false;
  String _processStatus = 'Siap sinkronisasi';

  // Simulasi operasi async untuk Kasus D
  Future<void> _simulateAsyncOperation() async {
    setState(() {
      _isLoading = true;
      _processStatus = 'Memproses data kursus...';
    });

    // Menunggu simulasi proses async selama 3 detik
    await Future.delayed(const Duration(seconds: 3));

    // =========================================================================
    // KASUS D: Cek apakah widget masih terpasang di tree sebelum panggil setState
    // Jika user menekan tombol Back sebelum 3 detik, fungsi langsung berhenti di sini.
    // =========================================================================
    if (!mounted) return;

    // Aman memanggil setState karena widget terbukti masih terpasang (mounted == true)
    setState(() {
      _isLoading = false;
      _processStatus = 'Sinkronisasi data kursus selesai!';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Operasi background berhasil diselesaikan!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        title: Text(
          widget.course.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kode Mata Kuliah: ${widget.course.code}',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Status Pembelajaran: ${widget.course.status}',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  const Text(
                    'Status Proses Asynchronous:',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _processStatus,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _isLoading ? Colors.orange.shade800 : Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _simulateAsyncOperation,
                icon: const Icon(Icons.sync),
                label: const Text(
                  'Mulai Proses Async (3 Detik)',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}