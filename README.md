# Secure Storage & HTTP

Flutter app latihan yang menggunakan `flutter_secure_storage` dan JSONPlaceholder.

## Fitur

- Login simulasi memakai email dan password apa saja. Token disimpan di secure
  storage, dan sesi yang tersimpan dibuka kembali saat aplikasi dijalankan.
- Logout meminta konfirmasi, menghapus token, lalu kembali ke halaman login.
- Daftar post dari `GET /posts`, termasuk `userId`, judul, dan isi post.
- Daftar pengguna dari `GET /users`, dengan pencarian langsung berdasarkan nama
  atau email.
- Timeout request pengguna dapat diatur ke 5, 10, atau 20 detik. Default API
  adalah 10 detik dan pesan timeout menampilkan batas waktu yang dipilih.

Jalankan aplikasi dengan `flutter run`. API memerlukan koneksi internet.
