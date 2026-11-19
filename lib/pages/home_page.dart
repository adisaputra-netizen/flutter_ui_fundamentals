import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/kos_service.dart';
import '../services/profile_service.dart';
import '../services/notification_service.dart';
import '../widgets/role_guard.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UserProfile?> _profileFuture;
  late Future<List<Map<String, dynamic>>> _kosFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getMyProfile();
    NotificationService.instance.init();
    _kosFuture = KosService().fetchAll();
  }

  void _refreshKos() {
    setState(() {
      _kosFuture = KosService().fetchAll();
    });
  }

  Future<void> _showAddDialog() async {
    final nameC = TextEditingController();
    final addressC = TextEditingController();
    final priceC = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Kos'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameC,
                    decoration: const InputDecoration(labelText: 'Nama Kos'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: addressC,
                    decoration: const InputDecoration(labelText: 'Alamat'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Alamat wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: priceC,
                    decoration: const InputDecoration(labelText: 'Harga (Rp)'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Harga wajib diisi';
                      }
                      if (int.tryParse(v.trim()) == null) {
                        return 'Harga harus berupa angka';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop(true);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        await KosService().add(
          name: nameC.text.trim(),
          address: addressC.text.trim(),
          price: int.parse(priceC.text.trim()),
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kos berhasil ditambahkan')),
        );
        _refreshKos();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambah kos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    nameC.dispose();
    addressC.dispose();
    priceC.dispose();
  }

  Future<void> _showEditDialog(Map<String, dynamic> kos) async {
    final nameC = TextEditingController(text: kos['name']?.toString() ?? '');
    final addressC =
        TextEditingController(text: kos['address']?.toString() ?? '');
    final priceC = TextEditingController(text: kos['price']?.toString() ?? '');
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Kos'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameC,
                    decoration: const InputDecoration(labelText: 'Nama Kos'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: addressC,
                    decoration: const InputDecoration(labelText: 'Alamat'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Alamat wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: priceC,
                    decoration: const InputDecoration(labelText: 'Harga (Rp)'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Harga wajib diisi';
                      }
                      if (int.tryParse(v.trim()) == null) {
                        return 'Harga harus berupa angka';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop(true);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        final success = await KosService().update(
          kos['id'].toString(),
          {
            'name': nameC.text.trim(),
            'address': addressC.text.trim(),
            'price': int.parse(priceC.text.trim()),
          },
        );
        if (!mounted) return;
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kos berhasil diperbarui')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal memperbarui kos (Akses ditolak RLS)'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        _refreshKos();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    nameC.dispose();
    addressC.dispose();
    priceC.dispose();
  }

  Future<void> _deleteKos(Map<String, dynamic> kos) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kos'),
        content: Text('Yakin ingin menghapus "${kos['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final success = await KosService().delete(kos['id'].toString());
        if (!mounted) return;
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kos berhasil dihapus')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menghapus kos (Akses ditolak RLS)'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        _refreshKos();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(
              child: Text('Gagal memuat profil'),
            ),
          );
        }

        final p = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text('KosFinder (${p.role})'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () async {
                  await AuthService.instance.logout();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async => _refreshKos(),
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(p.name.isEmpty ? p.email : p.name),
                  subtitle: Text('${p.email} • ${p.role}'),
                ),
                const Divider(),
                const ListTile(
                  leading: Icon(Icons.list),
                  title: Text('Daftar Kos'),
                ),
                if (p.isOwner || p.isAdmin)
                  const ListTile(
                    leading: Icon(Icons.home_work),
                    title: Text('My Kos'),
                  ),
                if (p.isAdmin)
                  const ListTile(
                    leading: Icon(Icons.admin_panel_settings),
                    title: Text('Kelola Data (Admin)'),
                  ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'Daftar Kos Tersedia',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _kosFuture,
                  builder: (context, kosSnapshot) {
                    if (kosSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (kosSnapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'Gagal memuat data kos: ${kosSnapshot.error}',
                          ),
                        ),
                      );
                    }

                    final kosList = kosSnapshot.data ?? [];
                    if (kosList.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(
                          child: Text('Belum ada data kos.'),
                        ),
                      );
                    }

                    final currentUserId =
                        Supabase.instance.client.auth.currentUser?.id;

                    return Column(
                      children: kosList.map((kos) {
                        final isOwner = kos['owner_id'] == currentUserId;
                        return ListTile(
                          leading: const Icon(Icons.home),
                          title: Text(kos['name']?.toString() ?? '-'),
                          subtitle: Text(
                            '${kos['address'] ?? '-'} • Rp ${kos['price'] ?? 0}',
                          ),
                          trailing: isOwner
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      tooltip: 'Edit',
                                      onPressed: () => _showEditDialog(kos),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      tooltip: 'Hapus',
                                      onPressed: () => _deleteKos(kos),
                                    ),
                                  ],
                                )
                              : null,
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: RoleGuard(
            role: p.role,
            allowed: const ['owner', 'admin'],
            child: FloatingActionButton.extended(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add_home),
              label: const Text('Tambah Kos'),
            ),
          ),
        );
      },
    );
  }
}
