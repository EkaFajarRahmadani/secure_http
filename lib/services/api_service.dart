import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/post.dart';
import '../models/user.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration defaultTimeout = Duration(seconds: 10);

  Future<List<User>> getUsers({Duration timeout = defaultTimeout}) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/users'))
          .timeout(timeout);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw HttpException(
          'Gagal memuat data. Status: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw TimeoutException(
        'Request timeout setelah ${timeout.inSeconds} detik. Coba lagi.',
      );
    } on SocketException {
      throw const SocketException(
        'Tidak ada koneksi internet. Periksa jaringan Anda.',
      );
    } on FormatException {
      throw const FormatException('Format data tidak valid.');
    }
  }

  Future<User> getUserById(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/users/$id'))
          .timeout(defaultTimeout);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw HttpException(
          'Gagal memuat data. Status: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw TimeoutException(
        'Request timeout setelah ${defaultTimeout.inSeconds} detik. Coba lagi.',
      );
    } on SocketException {
      throw const SocketException(
        'Tidak ada koneksi internet. Periksa jaringan Anda.',
      );
    }
  }

  Future<List<Post>> getPosts({Duration timeout = defaultTimeout}) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/posts'))
          .timeout(timeout);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      }
      throw HttpException('Gagal memuat data. Status: ${response.statusCode}');
    } on TimeoutException {
      throw TimeoutException(
        'Request timeout setelah ${timeout.inSeconds} detik. Coba lagi.',
      );
    } on SocketException {
      throw const SocketException(
        'Tidak ada koneksi internet. Periksa jaringan Anda.',
      );
    } on FormatException {
      throw const FormatException('Format data tidak valid.');
    }
  }

  Future<String> login(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      throw ArgumentError('Email dan password tidak boleh kosong.');
    }
    await Future<void>.delayed(const Duration(seconds: 1));
    return 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
  @override
  String toString() => message;
}
