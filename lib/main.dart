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
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Tahap 11',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AdaptiveNavigationShell(),
    );
  }
}

class AdaptiveNavigationShell extends StatefulWidget {
  const AdaptiveNavigationShell({super.key});

  @override
  State<AdaptiveNavigationShell> createState() =>
      _AdaptiveNavigationShellState();
}

class _AdaptiveNavigationShellState extends State<AdaptiveNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CoursesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint: jika lebar >= 840 px gunakan NavigationRail (Expanded)
        if (constraints.maxWidth >= 840) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'CE\n840+',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
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
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: _pages[_currentIndex],
                ),
              ],
            ),
          );
        }

        // Jika lebar < 840 px gunakan NavigationBar (Compact / Medium)
        return Scaffold(
          body: _pages[_currentIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
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

// ---------------- Halaman 1: Home ----------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer - Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.devices, size: 72, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'Adaptive Navigation Pattern',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Praktikan: $studentName ($studentId)',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              const Text(
                'Ubah orientasi atau ukuran window untuk melihat transisi NavigationBar ↔ NavigationRail',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Halaman 2: Courses ----------------
class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  final List<Map<String, String>> dummyCourses = const [
    {'code': 'MOB04', 'name': 'Responsive Layout', 'status': 'Active'},
    {'code': 'MOB05', 'name': 'Navigation Stack', 'status': 'Active'},
    {'code': 'MOB06', 'name': 'User Interaction', 'status': 'Planned'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Course'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyCourses.length,
        itemBuilder: (context, index) {
          final item = dummyCourses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.book, color: Colors.blue),
              title: Text(
                item['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item['code']!),
              trailing: Chip(
                label: Text(
                  item['status']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: item['status'] == 'Active' ? Colors.green : Colors.grey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------- Halaman 3: Profile ----------------
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 48,
                child: Icon(Icons.person, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                studentName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'NIM: $studentId',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Chip(label: Text('Pendidikan Teknik Informatika')),
            ],
          ),
        ),
      ),
    );
  }
}