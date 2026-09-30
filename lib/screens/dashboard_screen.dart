import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/dashboard_service.dart';
import '../widgets/summary_card.dart';
import '../widgets/course_item_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<DashboardData> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = DashboardService.fetchDashboardData();
  }

  void _reloadDashboard() {
    setState(() {
      _dashboardFuture = DashboardService.fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learning Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload Data',
            onPressed: _reloadDashboard,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<DashboardData>(
          future: _dashboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text(
                      'Memuat data modular...',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 10),
                      Text(
                        'Terjadi Kesalahan:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: _reloadDashboard,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (snapshot.hasData) {
              final student = snapshot.data!.student;
              final courses = snapshot.data!.courses;

              final int totalCourses = courses.length;
              final int totalCredits =
                  courses.fold(0, (sum, item) => sum + item.credits);
              final int completedCourses =
                  courses.where((c) => c.status == 'Selesai').length;

              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Identity Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 32,
                              backgroundImage:
                                  AssetImage('assets/images/profile.jpg'),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'NIM: ${student.nim}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    student.program,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    student.university,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Summary Cards
                    Row(
                      children: [
                        SummaryCard(
                          title: 'Total Matakuliah',
                          value: '$totalCourses',
                          icon: Icons.book,
                          color: Colors.blue.shade700,
                        ),
                        SummaryCard(
                          title: 'Total Beban SKS',
                          value: '$totalCredits SKS',
                          icon: Icons.credit_score,
                          color: Colors.purple.shade700,
                        ),
                        SummaryCard(
                          title: 'MK Selesai',
                          value: '$completedCourses',
                          icon: Icons.check_circle_outline,
                          color: Colors.green.shade700,
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Header List
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daftar Topik / Matakuliah',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$completedCourses dari $totalCourses Selesai',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // List View Builder
                    Expanded(
                      child: ListView.separated(
                        itemCount: courses.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          return CourseItemCard(course: courses[index]);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('Data tidak tersedia'));
          },
        ),
      ),
    );
  }
}