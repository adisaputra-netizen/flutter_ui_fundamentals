import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import 'course_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favList = context.watch<CourseProvider>().courses.where((c) => c.isFavorite).toList();

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailScreen(course: item),
                ),
              );
            },
            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item.code),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () => context.read<CourseProvider>().toggleFavorite(item),
            ),
          ),
        );
      },
    );
  }
}