import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'screens/home_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/favorites_screen.dart';
import 'models/course_item.dart';

// Identitas Mahasiswa (Wajib)
const String studentName = 'Kadek Adi Saputra';
const String studentId = '2415051005';

// Konstanta URL Endpoint Resmi Latihan
const String apiUrl = 'https://course-api-pearl.vercel.app/courses';

Future<List<Course>> fetchCourses() async {
  try {
    print('--> Sedang mengambil data dari API...');
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> rawList = jsonDecode(response.body) as List<dynamic>;
      
      // Konversi List<dynamic> JSON menjadi List<Course>
      final List<Course> courseList = rawList
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList();

      print('=== [Tahap 3] Berhasil parsing JSON ke Model Course! ===');
      for (var c in courseList.take(3)) {
        print('Course: ${c.code} - ${c.title} (${c.credits} SKS) [Status: ${c.status}]');
      }

      return courseList;
    } else {
      print('Gagal memuat data. Status: ${response.statusCode}');
    }
  } catch (e) {
    print('Terjadi kesalahan saat parsing Model Course: $e');
  }

  throw Exception('Gagal mengambil courses');
}

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CourseProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Course Explorer v2',
        home: MainShellPage(),
      ),
    );
  }
}

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCourses(); // <-- Panggil di sini
  }

  final List<Widget> _pages = const [
    HomeScreen(studentId: studentId, studentName: studentName),
    CoursesScreen(),
    FavoritesScreen(),
  ];

  // ... sisa kode ke bawah biarkan tetap sama

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        title: const Text(
          'Course Explorer v2',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        color: const Color(0xFFE3EFFC),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, 'Home'),
            _buildNavItem(1, 'Courses'),
            _buildNavItem(2, 'Favorites'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            color: const Color(0xFF154A82),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}