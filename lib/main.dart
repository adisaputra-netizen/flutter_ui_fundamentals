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

// ==================== TAHAP 5: CHANGENOTIFIER MODEL ====================
// Mengelola business logic & shared state di luar widget tree
class CourseChangeNotifier extends ChangeNotifier {
  final List<CourseItem> _courses = [
    CourseItem(code: 'GIT01', title: 'Git & GitHub', status: 'done', isFavorite: true),
    CourseItem(code: 'MOB01', title: 'Dart Fundamentals', status: 'done', isFavorite: true),
    CourseItem(code: 'MOB07', title: 'State Management', status: 'active', isFavorite: false),
    CourseItem(code: 'MOB04', title: 'Responsive Layout', status: 'active', isFavorite: false),
    CourseItem(code: 'MOB05', title: 'Navigation & Routing', status: 'planned', isFavorite: false),
  ];

  List<CourseItem> get courses => _courses;
  int get favoritesCount => _courses.where((c) => c.isFavorite).length;

  void toggleFavorite(CourseItem course) {
    course.isFavorite = !course.isFavorite;
    // Beri tahu seluruh listener yang memantau objek ini
    notifyListeners();
  }
}

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 0;
  // Instansiasi ChangeNotifier sebagai sumber data tunggal
  late final CourseChangeNotifier _courseNotifier;

  @override
  void initState() {
    super.initState();
    _courseNotifier = CourseChangeNotifier();
  }

  @override
  void dispose() {
    _courseNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder mendengarkan perubahan dari ChangeNotifier
    return ListenableBuilder(
      listenable: _courseNotifier,
      builder: (context, child) {
        final List<Widget> pages = [
          HomeScreen(courseNotifier: _courseNotifier),
          CoursesScreen(courseNotifier: _courseNotifier),
          FavoritesScreen(courseNotifier: _courseNotifier),
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
      },
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
  final CourseChangeNotifier courseNotifier;

  const HomeScreen({
    super.key,
    required this.courseNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final courses = courseNotifier.courses;
    final favoritesCount = courseNotifier.favoritesCount;

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

        // Dua Summary Card: Courses & Favorites (Otomatis sinkron via ChangeNotifier)
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
        ...courses.take(3).map(
              (item) => _buildCourseCard(
                item,
                onToggle: () => courseNotifier.toggleFavorite(item),
              ),
            ),

        const SizedBox(height: 16),

        // >>> WIDGET TAHAP 5: CHANGENOTIFIER CARD <<<
        Stage5ChangeNotifierCard(courseNotifier: courseNotifier),
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

  Widget _buildCourseCard(CourseItem item, {required VoidCallback onToggle}) {
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
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }
}

// ==================== WIDGET TAHAP 5 ====================
class Stage5ChangeNotifierCard extends StatelessWidget {
  final CourseChangeNotifier courseNotifier;

  const Stage5ChangeNotifierCard({
    super.key,
    required this.courseNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final mob07 = courseNotifier.courses.firstWhere((c) => c.code == 'MOB07');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF80CBC4), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tahap 5: ChangeNotifier Pattern',
                    style: TextStyle(
                      color: Color(0xFF00695C),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$studentId • $studentName',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const Icon(Icons.sync, color: Color(0xFF00695C), size: 22),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${mob07.title}: ${mob07.isFavorite ? "Favorit" : "Bukan Favorit"}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF004D40),
                    ),
                  ),
                ),
                FilledButton.tonal(
                  onPressed: () => courseNotifier.toggleFavorite(mob07),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF80CBC4),
                  ),
                  child: Text(
                    mob07.isFavorite ? 'Batalkan' : 'Favoritkan',
                    style: const TextStyle(color: Color(0xFF004D40), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'State dikelola oleh class mandiri turunan ChangeNotifier via notifyListeners().',
            style: TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

// ---------------- 2. COURSES SCREEN ----------------
class CoursesScreen extends StatelessWidget {
  final CourseChangeNotifier courseNotifier;

  const CoursesScreen({
    super.key,
    required this.courseNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final courses = courseNotifier.courses;

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
              onPressed: () => courseNotifier.toggleFavorite(item),
            ),
          ),
        );
      },
    );
  }
}

// ---------------- 3. FAVORITES SCREEN ----------------
class FavoritesScreen extends StatelessWidget {
  final CourseChangeNotifier courseNotifier;

  const FavoritesScreen({
    super.key,
    required this.courseNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final favList = courseNotifier.courses.where((c) => c.isFavorite).toList();

    if (favList.isEmpty) {
      return const Center(child: Text('Belum ada materi favorit.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favList.length,
      itemBuilder: (context, index) {
        final item = favList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item.code),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () => courseNotifier.toggleFavorite(item),
            ),
          ),
        );
      },
    );
  }
}