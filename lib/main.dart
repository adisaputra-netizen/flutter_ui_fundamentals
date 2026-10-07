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

  final List<CourseItem> _courses = [
    CourseItem(code: 'GIT01', title: 'Git & GitHub', status: 'done', isFavorite: true),
    CourseItem(code: 'MOB01', title: 'Dart Fundamentals', status: 'done', isFavorite: true),
    CourseItem(code: 'MOB07', title: 'State Management', status: 'active', isFavorite: false),
    CourseItem(code: 'MOB04', title: 'Responsive Layout', status: 'active', isFavorite: false),
    CourseItem(code: 'MOB05', title: 'Navigation & Routing', status: 'planned', isFavorite: false),
  ];

  // State untuk demonstrasi Tahap 2 yang dimiliki oleh parent
  int _drilledCounter = 0;

  void _incrementDrilledCounter() {
    setState(() {
      _drilledCounter++;
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
        drilledCounter: _drilledCounter,
        onIncrementDrilled: _incrementDrilledCounter,
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
  final int drilledCounter;
  final VoidCallback onIncrementDrilled;
  final Function(CourseItem) onToggleFavorite;

  const HomeScreen({
    super.key,
    required this.courses,
    required this.favoritesCount,
    required this.drilledCounter,
    required this.onIncrementDrilled,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // 1. Kartu Identitas Mahasiswa (Paling Atas)
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

        // 2. Dua Summary Card: Courses & Favorites
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

        // 3. Daftar 3 Kursus Teratas
        ...courses.take(3).map((item) => _buildCourseCard(item)),

        const SizedBox(height: 16),

        // 4. Kartu Eksperimen Tahap 2 Dipindah ke Bagian Bawah
        PropDrillingLevel1Card(
          counter: drilledCounter,
          onIncrement: onIncrementDrilled,
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

// ==================== WIDGET TAHAP 2: PROP DRILLING ====================
// Child Level 1: Hanya menjadi jembatan pengoper props ke widget bawahnya
class PropDrillingLevel1Card extends StatelessWidget {
  final int counter;
  final VoidCallback onIncrement;

  const PropDrillingLevel1Card({
    super.key,
    required this.counter,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF5A623), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tahap 2: Prop Drilling Experiment',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFFD08005),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Parent meneruskan nilai counter & callback melalui Level 1 Widget:',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          // Meneruskan data lagi ke child terdalam (Level 2)
          PropDrillingLevel2Action(
            currentValue: counter,
            onActionPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}

// Child Level 2: Widget anak terdalam yang menerima data dan mengeksekusi callback
class PropDrillingLevel2Action extends StatelessWidget {
  final int currentValue;
  final VoidCallback onActionPressed;

  const PropDrillingLevel2Action({
    super.key,
    required this.currentValue,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Diterima di Level 2: $currentValue',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          OutlinedButton.icon(
            onPressed: onActionPressed,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Tambah via Callback'),
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