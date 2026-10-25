import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase

import 'constants/supabase_constants.dart';
import 'models/course_item.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'services/course_api_service.dart';
import 'screens/home_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/favorites_screen.dart';

const String studentName = 'Kadek Adi Saputra';
const String studentId = '2415051005';
const String apiBaseUrl = 'https://course-api-pearl.vercel.app';

Future<void> main() async {
  // Poin 61: Pastikan binding engine Flutter terinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Poin 61 & 63: Inisialisasi Supabase Client dengan anonKey
  await Supabase.initialize(
    url: SupabaseConstants.url,
    anonKey: SupabaseConstants.anonKey,
  );

  // Poin 62: Perakitan service -> repository -> provider tetap berjalan
  final apiService = CourseApiService(apiBaseUrl);
  final repository = CourseRepository(apiService);

  runApp(
    ChangeNotifierProvider(
      create: (context) => CourseProvider(repository)..loadCourses(),
      child: const CourseExplorerApp(),
    ),
  );
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer v2',
      home: const MainShellPage(),
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

  final List<Widget> _pages = const [
    HomeScreen(studentId: studentId, studentName: studentName),
    CoursesScreen(),
    FavoritesScreen(),
  ];

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