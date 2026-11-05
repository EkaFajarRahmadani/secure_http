import 'package:flutter/material.dart';

import '../services/secure_storage_service.dart';
import 'login_screen.dart';
import 'post_list_screen.dart';
import 'user_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SecureStorageService _storageService = SecureStorageService();
  String? _savedToken;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    try {
      final token = await _storageService.getToken();
      if (mounted) {
        setState(() {
          _savedToken = token;
          _errorMessage = null;
        });
      }
    } on Exception catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal membaca token: $error';
        });
      }
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi logout'),
        content: const Text(
          'Token akan dihapus dari secure storage. Anda yakin ingin logout?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      await _storageService.deleteToken();
      if (!mounted) return;
      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    } on Exception catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Logout gagal: $error')));
      }
    }
  }

  void _openUsers() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const UserListScreen()),
    );
  }

  void _openPosts() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const PostListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final token = _savedToken;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Storage & HTTP'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.verified_user, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text(
                        'Status Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
                  else if (token == null)
                    const Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Belum login'),
                      ],
                    )
                  else
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Login berhasil. Token tersimpan dengan aman.'),
                      ],
                    ),
                  if (token != null) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Token tersimpan (nilai dirahasiakan)',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                  if (_errorMessage != null)
                    TextButton.icon(
                      onPressed: _loadToken,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba lagi'),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.cloud, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'HTTP Request',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Data diambil dari JSONPlaceholder menggunakan GET request.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _openPosts,
                      icon: const Icon(Icons.article),
                      label: const Text('Lihat Daftar Post'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _openUsers,
                      icon: const Icon(Icons.people),
                      label: const Text('Lihat Daftar Pengguna'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.amber[50],
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Token disimpan terenkripsi di secure storage. Jangan mencetak '
                'token atau password ke log, dan gunakan HTTPS untuk API.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
