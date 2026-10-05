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
      title: 'Course Explorer',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D6EFD),
        ),
      ),
      home: const ResponsiveShell(),
    );
  }
}

// Model Data Course
class Course {
  final String code;
  final String title;
  final String description;
  final String status;
  bool isFavorite;

  Course({
    required this.code,
    required this.title,
    required this.description,
    required this.status,
    this.isFavorite = false,
  });
}

// ---------------- 1. SHELL UTAMA (ADAPTIVE NAVIGATION) ----------------
class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _currentIndex = 0;

  // Koleksi Data Minimal 5 Item
  final List<Course> _courses = [
    Course(
      code: 'MOB01',
      title: 'Dart Fundamentals',
      description: 'Pemrograman berorientasi objek dan tipe data modern di Dart.',
      status: 'Completed',
    ),
    Course(
      code: 'MOB02',
      title: 'Widget Dasar & Layout',
      description: 'Membangun antarmuka Flutter menggunakan Column, Row, dan Container.',
      status: 'Completed',
    ),
    Course(
      code: 'MOB04',
      title: 'Responsive Layout',
      description: 'Menyesuaikan UI dengan MediaQuery, LayoutBuilder, dan Breakpoint.',
      status: 'Active',
    ),
    Course(
      code: 'MOB05',
      title: 'Navigation & Routing',
      description: 'Navigasi stack, pop result, serta shell NavigationBar dan NavigationRail.',
      status: 'Active',
    ),
    Course(
      code: 'MOB06',
      title: 'User Interaction & Form',
      description: 'Menangani sentuhan InkWell, validasi Form, dan feedback Dialog/SnackBar.',
      status: 'Planned',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(courses: _courses),
      CoursesPage(
        courses: _courses,
        onFavoriteToggle: (course) {
          setState(() {
            course.isFavorite = !course.isFavorite;
          });
        },
      ),
      ProfilePage(studentName: studentName, studentId: studentId),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Layar Lebar: NavigationRail (>= 840 px)
        if (constraints.maxWidth >= 840) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Course Explorer (Expanded)'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text('$studentName - $studentId',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _currentIndex = index),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.school_outlined),
                      selectedIcon: Icon(Icons.school),
                      label: Text('Courses'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: pages[_currentIndex]),
              ],
            ),
          );
        }

        // Layar Sempit: NavigationBar (< 840 px)
        return Scaffold(
          appBar: AppBar(
            title: const Text('Course Explorer'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: pages[_currentIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) =>
                setState(() => _currentIndex = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.school_outlined),
                selectedIcon: Icon(Icons.school),
                label: 'Courses',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------- 2. HALAMAN HOME ----------------
class HomePage extends StatelessWidget {
  final List<Course> courses;
  const HomePage({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    final activeCourses = courses.where((c) => c.status == 'Active').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Pengantar
          Card(
            color: Colors.blue.shade50,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.blue.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, $studentName!',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('NIM: $studentId | PTI Undiksha'),
                  const SizedBox(height: 8),
                  const Text(
                    'Kelola dan pantau seluruh materi pembelajaran mobile Flutter secara adaptif dan interaktif.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Materi Aktif Saat Ini',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...activeCourses.map(
            (c) => ListTile(
              leading: const Icon(Icons.play_circle_outline, color: Colors.blue),
              title: Text(c.title),
              subtitle: Text(c.code),
              trailing: const Chip(
                label: Text('Active', style: TextStyle(fontSize: 11)),
                backgroundColor: Colors.lightGreenAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- 3. HALAMAN COURSES (ADAPTIVE GRID/LIST) ----------------
class CoursesPage extends StatelessWidget {
  final List<Course> courses;
  final Function(Course) onFavoriteToggle;

  const CoursesPage({
    super.key,
    required this.courses,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint Responsif Kolom Grid
        int crossAxisCount = 1;
        if (constraints.maxWidth >= 900) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth >= 600) {
          crossAxisCount = 2;
        }

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: crossAxisCount == 1
              ? ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return CourseCard(
                      course: course,
                      onFavoriteToggle: () => onFavoriteToggle(course),
                      onTap: () => _navigateToDetail(context, course),
                    );
                  },
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return CourseCard(
                      course: course,
                      onFavoriteToggle: () => onFavoriteToggle(course),
                      onTap: () => _navigateToDetail(context, course),
                    );
                  },
                ),
        );
      },
    );
  }

  void _navigateToDetail(BuildContext context, Course course) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailPage(course: course),
      ),
    );

    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status favorit untuk ${course.title} diperbarui.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

// ---------------- REUSABLE WIDGET: CARD COURSE ----------------
class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.menu_book, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${course.code} • ${course.status}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  course.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: course.isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: onFavoriteToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- 4. DETAIL PAGE (PASSING & RETURNING DATA) ----------------
class CourseDetailPage extends StatefulWidget {
  final Course course;
  const CourseDetailPage({super.key, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  late bool _favState;

  @override
  void initState() {
    super.initState();
    _favState = widget.course.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.course.code} - ${widget.course.title}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text('Status: ${widget.course.status}'),
              backgroundColor: Colors.blue.shade50,
            ),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi Materi:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(widget.course.description, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 24),
            const Divider(),
            Text('Praktikan Terdaftar: $studentName ($studentId)',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _favState = !_favState;
                        widget.course.isFavorite = _favState;
                      });
                    },
                    icon: Icon(
                      _favState ? Icons.favorite : Icons.favorite_border,
                      color: _favState ? Colors.red : Colors.grey,
                    ),
                    label: Text(_favState ? 'Favorit Aktif' : 'Tambah Favorit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Simpan & Kembali'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- 5. HALAMAN PROFILE & FEEDBACK FORM ----------------
class ProfilePage extends StatefulWidget {
  final String studentName;
  final String studentId;

  const ProfilePage({
    super.key,
    required this.studentName,
    required this.studentId,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();

  void _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kirim Ulasan?'),
        content: const Text('Pastikan saran yang dimasukkan sudah sesuai sebelum dikirim.'),
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
      ),
    );

    if (confirm == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback berhasil terkirim! Terima kasih.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _commentController.clear();
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 44,
            child: Icon(Icons.person, size: 48),
          ),
          const SizedBox(height: 12),
          Text(
            widget.studentName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('NIM: ${widget.studentId}',
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          // Form Feedback
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Form Evaluasi & Masukan Materi',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _commentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Saran & Masukan',
                        hintText: 'Tulis ulasan minimal 5 karakter...',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Kolom ini wajib diisi';
                        }
                        if (val.trim().length < 5) {
                          return 'Minimal 5 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _submitFeedback,
                      icon: const Icon(Icons.send),
                      label: const Text('Kirim Masukan'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}