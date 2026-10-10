import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Identitas Mahasiswa (Wajib)
const String studentName = 'Kadek Adi Saputra';
const String studentId = '2415051005';

void main() {
  runApp(
    // Menginjeksi CourseChangeNotifier ke seluruh hierarki widget tree
    ChangeNotifierProvider(
      create: (context) => CourseChangeNotifier(),
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
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7FAFD),
        useMaterial3: true,
      ),
      home: const MainShellPage(),
    );
  }
}

// Model Data Kursus
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

// State Holder Menggunakan ChangeNotifier
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
    notifyListeners();
  }
}

// Shell Navigasi Utama
class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
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

// ---------------- 1. HOME SCREEN ----------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca state menggunakan context.watch dari Provider
    final courseNotifier = context.watch<CourseChangeNotifier>();
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

        // Summary Box
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
                context,
                item,
              ),
            ),

        const SizedBox(height: 16),

        // >>> WIDGET TAHAP 6: PROVIDER & CONSUMER CARD <<<
        const Stage6ProviderConsumerCard(),
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

  Widget _buildCourseCard(BuildContext context, CourseItem item) {
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
            // Mengirim aksi perubahan menggunakan context.read
            onPressed: () => context.read<CourseChangeNotifier>().toggleFavorite(item),
          ),
        ],
      ),
    );
  }
}

// ==================== WIDGET TAHAP 6: PROVIDER & CONSUMER ====================
class Stage6ProviderConsumerCard extends StatelessWidget {
  const Stage6ProviderConsumerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF90CAF9), width: 1.2),
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
                    'Tahap 6: Provider & Consumer Pattern',
                    style: TextStyle(
                      color: Color(0xFF1565C0),
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
              const Icon(Icons.hub_outlined, color: Color(0xFF1565C0), size: 22),
            ],
          ),
          const SizedBox(height: 14),
          // Menggunakan Consumer untuk membatasi rebuild hanya pada container ini
          Consumer<CourseChangeNotifier>(
            builder: (context, notifier, child) {
              final mob07 = notifier.courses.firstWhere((c) => c.code == 'MOB07');
              final isFav = mob07.isFavorite;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${mob07.title}: ${isFav ? "Favorit" : "Bukan Favorit"}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => notifier.toggleFavorite(mob07),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFav ? Colors.red : const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        elevation: 1,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                      ),
                      label: Text(
                        isFav ? 'Batalkan' : 'Favoritkan',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          const Text(
            'State diakses langsung via Provider/Consumer tanpa meneruskan parameter melalui constructor.',
            style: TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

// ---------------- 2. COURSES SCREEN ----------------
class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courseNotifier = context.watch<CourseChangeNotifier>();
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
              onPressed: () => context.read<CourseChangeNotifier>().toggleFavorite(item),
            ),
          ),
        );
      },
    );
  }
}

// ---------------- 3. FAVORITES SCREEN ----------------
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courseNotifier = context.watch<CourseChangeNotifier>();
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
              onPressed: () => context.read<CourseChangeNotifier>().toggleFavorite(item),
            ),
          ),
        );
      },
    );
  }
}