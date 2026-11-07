import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Informasi UTS'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Student Profile Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 46,
                      backgroundColor: Colors.orange.shade100,
                      child: const CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.deepOrange,
                        child: Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Kynan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'NIM: 2415051040 • Kelas PTI 5C',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pendidikan Teknik Informatika\nUniversitas Pendidikan Ganesha (Undiksha)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // UTS Assignment & Dosen Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.school, color: Colors.deepOrange),
                        SizedBox(width: 8),
                        Text(
                          'Informasi Ujian Tengah Semester',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    _buildInfoRow('Mata Kuliah', 'Pemrograman Berbasis Mobile'),
                    _buildInfoRow('Tema Project', 'Rental Motor (MotoRent)'),
                    _buildInfoRow('Dosen Pengampu',
                        'Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom'),
                    _buildInfoRow('Teaching Assistant', 'Made Yuda Sadewa, S.Pd.'),
                    _buildInfoRow(
                        'Repositori GitHub', 'UTS_2415051040_Kynan'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Architecture & Tech Stack Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.architecture, color: Colors.teal),
                        SizedBox(width: 8),
                        Text(
                          'Arsitektur & Tech Stack',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    _buildInfoRow('Arsitektur',
                        'Clean Architecture:\nUI → Provider → Repository → Service → API/DB'),
                    _buildInfoRow('State Management',
                        'Provider + ChangeNotifier (MultiProvider)'),
                    _buildInfoRow('REST API',
                        'GET HTTP Client Katalog Motor + Offline Fallback'),
                    _buildInfoRow('Database Backend',
                        'SQLite (sqflite / sqflite_common_ffi)\nTabel: rental_bookings (CRUD lengkap)'),
                    _buildInfoRow('Responsive Layout',
                        'LayoutBuilder: Compact (< 600px) & Wide (>= 600px)'),
                    _buildInfoRow('Reusable Widgets',
                        'MotorCard, RentalCard, StatusBadge, RatingStars, CustomButton'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Screen Checklist Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Daftar Screen Aplikasi (7 Screen)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    _buildChecklistItem('1. DashboardScreen',
                        'Statistik rental, profil mahasiswa, kategori motor, rekomendasi.'),
                    _buildChecklistItem('2. MotorListScreen',
                        'Katalog responsif (List/Grid) REST API dengan search & filter.'),
                    _buildChecklistItem('3. MotorDetailScreen',
                        'Spesifikasi CC/transmisi, fasilitas rental, passing data, kontak WA.'),
                    _buildChecklistItem('4. FavoritesScreen',
                        'Riwayat sewa dari database SQLite dengan dialog konfirmasi hapus.'),
                    _buildChecklistItem('5. AddRentalScreen (Create)',
                        'Form validasi pencatatan rental motor baru ke database.'),
                    _buildChecklistItem('6. EditRentalScreen (Update)',
                        'Form validasi pembaruan catatan durasi & rating sewa di database.'),
                    _buildChecklistItem('7. ProfileScreen',
                        'Identitas pengembang Kynan, info dosen, dan diagram arsitektur.'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            Text(
              '© 2026 Kynan • PTI 5C • Undiksha',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 12, color: Colors.black87),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: description,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
