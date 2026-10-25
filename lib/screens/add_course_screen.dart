import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course_item.dart';
import '../providers/course_provider.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();

  String _selectedStatus = 'planned';
  bool _isSaving = false; // Poin 37: flag loading tombol

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    // Poin 35: Validasi field
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final newCourse = Course(
      code: _codeController.text.trim(),
      title: _titleController.text.trim(),
      credits: int.parse(_creditsController.text.trim()),
      status: _selectedStatus,
    );

    // Poin 36: Simpan melalui Provider
    final success = await context.read<CourseProvider>().addCourse(newCourse);

    // Poin 39: Cek context.mounted setelah proses asynchronous
    if (!mounted) return;

    setState(() => _isSaving = false);

    // Poin 38: Tampilkan SnackBar notifikasi
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menambahkan course!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Course Baru'),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Kode Mata Kuliah',
                  border: OutlineInputBorder(),
                  hintText: 'Misal: MOB08',
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Kode wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mata Kuliah',
                  border: OutlineInputBorder(),
                  hintText: 'Misal: Advanced Flutter',
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Nama course wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _creditsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'SKS (Credits)',
                  border: OutlineInputBorder(),
                  hintText: 'Misal: 3',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'SKS wajib diisi';
                  if (int.tryParse(val.trim()) == null) return 'SKS harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status Course',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'planned', child: Text('Planned')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'done', child: Text('Done')),
                ],
                onChanged: (val) => setState(() => _selectedStatus = val!),
              ),
              const SizedBox(height: 24),
              // Poin 37: Tombol dinonaktifkan saat sedang menyimpan
              ElevatedButton(
                onPressed: _isSaving ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Simpan Course',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}