import 'package:flutter/material.dart';

// Identitas Mahasiswa (Wajib)
const String studentName = 'Kadek Adi Saputra';
const String studentId = '2415051005';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer v2',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7FAFD),
        useMaterial3: true,
      ),
      home: const MainShellPage(),
    );
  }
}

// Model Data Dasar
class CourseItem {
  final String code;
  final String title;
  final String status;
  bool isFavorite;

  CourseItem({
    required this.code,
    required this.title,
    required this.status,
    this.isFavorite = false,
  });
}

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 0;

  // Single Source of Truth untuk data kursus
  final List<CourseItem> _courses = [
    CourseItem(code: 'GIT01', title: 'Git & GitHub', status: 'done', isFavorite: true),
    CourseItem(code: 'MOB01', title: 'Dart Fundamentals', status: 'done', isFavorite: true),
    CourseItem(code: 'MOB07', title: 'State Management', status: 'active', isFavorite: false),
    CourseItem(code: 'MOB04', title: 'Responsive Layout', status: 'active', isFavorite: false),
    CourseItem(code: 'MOB05', title: 'Navigation & Routing', status: 'planned', isFavorite: false),
  ];

  // SINGLE SOURCE OF TRUTH untuk Tahap 3 (disimpan di Parent)
  bool _stage3Favorite = false;

  void _toggleStage3Favorite() {
    setState(() {
      _stage3Favorite = !_stage3Favorite;
    });
  }

  void _toggleFavorite(CourseItem course) {
    setState(() {
      course.isFavorite = !course.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesCount = _courses.where((c) => c.isFavorite).length;

    final List<Widget> pages = [
      HomeScreen(
        courses: _courses,
        favoritesCount: favoritesCount,
        stage3Favorite: _stage3Favorite,
        onToggleStage3: _toggleStage3Favorite,
        onToggleFavorite: _toggleFavorite,
      ),
      CoursesScreen(
        courses: _courses,
        onToggleFavorite: _toggleFavorite,
      ),
      FavoritesScreen(
        courses: _courses.where((c) => c.isFavorite).toList(),
        onToggleFavorite: _toggleFavorite,
      ),
    ];

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
      body: pages[_currentIndex],
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

// ---------------- 1. HOME SCREEN ----------------
class HomeScreen extends StatelessWidget {
  final List<CourseItem> courses;
  final int favoritesCount;
  final bool stage3Favorite;
  final VoidCallback onToggleStage3;
  final Function(CourseItem) onToggleFavorite;

  const HomeScreen({
    super.key,
    required this.courses,
    required this.favoritesCount,
    required this.stage3Favorite,
    required this.onToggleStage3,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Kartu Identitas Mahasiswa
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFEBF3FC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            '$studentId • $studentName',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF19426D),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Dua Summary Card: Courses & Favorites
        Row(
          children: [
            Expanded(
              child: _buildSummaryBox('Courses', courses.length.toString()),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildSummaryBox('Favorites', favoritesCount.toString()),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Daftar 3 Kursus Teratas
        ...courses.take(3).map((item) => _buildCourseCard(item)),

        const SizedBox(height: 16),

        // >>> WIDGET TAHAP 3: LIFTING STATE UP & SINGLE SOURCE OF TRUTH <<<
        LiftingStateStage3Card(
          isFavorite: stage3Favorite,
          onToggle: onToggleStage3,
        ),
      ],
    );
  }

  Widget _buildSummaryBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF3FC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBDD8F5), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF4A6887)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF19426D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(CourseItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBDD8F5), width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF19426D),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.status,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00796B),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              item.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: item.isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () => onToggleFavorite(item),
          ),
        ],
      ),
    );
  }
}

// ==================== WIDGET TAHAP 3 ====================
class LiftingStateStage3Card extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onToggle;

  const LiftingStateStage3Card({
    super.key,
    required this.isFavorite,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.teal.shade300, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tahap 3: Lifting State Up & Single Source of Truth',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 8),
          // Child 1: Widget yang membaca status
          ChildStatusSummary(isFavorite: isFavorite),
          const SizedBox(height: 8),
          // Child 2: Widget yang mengeksekusi callback perubahan
          ChildCourseActionCard(
            title: 'State Management Course',
            isFavorite: isFavorite,
            onFavoriteChanged: onToggle,
          ),
        ],
      ),
    );
  }
}

// Child 1: Hanya menampilkan ringkasan berdasarkan data dari parent
class ChildStatusSummary extends StatelessWidget {
  final bool isFavorite;
  const ChildStatusSummary({super.key, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isFavorite ? Colors.teal.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(
            isFavorite ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isFavorite ? Colors.teal : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            isFavorite ? 'Status: Ditandai sebagai Favorit' : 'Status: Belum Favorit',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isFavorite ? Colors.teal.shade900 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// Child 2: Mengirim aksi kembali ke parent melalui callback
class ChildCourseActionCard extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  const ChildCourseActionCard({
    super.key,
    required this.title,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: onFavoriteChanged,
          ),
        ],
      ),
    );
  }
}

// ---------------- 2. COURSES SCREEN ----------------
class CoursesScreen extends StatelessWidget {
  final List<CourseItem> courses;
  final Function(CourseItem) onToggleFavorite;

  const CoursesScreen({
    super.key,
    required this.courses,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final item = courses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${item.code} • Status: ${item.status}'),
            trailing: IconButton(
              icon: Icon(
                item.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: item.isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () => onToggleFavorite(item),
            ),
          ),
        );
      },
    );
  }
}

// ---------------- 3. FAVORITES SCREEN ----------------
class FavoritesScreen extends StatelessWidget {
  final List<CourseItem> courses;
  final Function(CourseItem) onToggleFavorite;

  const FavoritesScreen({
    super.key,
    required this.courses,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const Center(child: Text('Belum ada materi favorit.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final item = courses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item.code),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () => onToggleFavorite(item),
            ),
          ),
        );
      },
    );
  }
}