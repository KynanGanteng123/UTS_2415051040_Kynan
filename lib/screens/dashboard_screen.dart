import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/motor_provider.dart';
import '../providers/rental_provider.dart';
import '../widgets/motor_card_widget.dart';
import 'motor_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const DashboardScreen({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.two_wheeler, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'MotoRent Singaraja',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            tooltip: 'Rental Tersimpan',
            onPressed: () => onNavigateToTab(2),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<MotorProvider>(context, listen: false).fetchMotors();
          if (context.mounted) {
            await Provider.of<RentalProvider>(context, listen: false)
                .loadBookings();
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Profil Mahasiswa & Ucapan Selamat Datang
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.deepOrange, Colors.orangeAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white.withValues(alpha: 0.25),
                            child: const Icon(Icons.person,
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kynan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'NIM: 2415051040 • PTI 5C',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Sewa Motor Praktis, Murah, dan Terpercaya di Singaraja Bali!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Statistics Cards (REST API vs SQLite)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Consumer<MotorProvider>(
                        builder: (context, provider, _) => _buildStatCard(
                          icon: Icons.two_wheeler,
                          color: Colors.deepOrange,
                          title: 'Armada Motor',
                          value: '${provider.motors.length} Unit',
                          subtitle: 'Sumber: REST API',
                          onTap: () => onNavigateToTab(1),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Consumer<RentalProvider>(
                        builder: (context, rental, _) => _buildStatCard(
                          icon: Icons.book_online,
                          color: Colors.teal,
                          title: 'Booking Aktif',
                          value: '${rental.totalBookingsCount} Sewa',
                          subtitle: 'Database SQLite',
                          onTap: () => onNavigateToTab(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Kategori Tipe Motor
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kategori Motor',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => onNavigateToTab(1),
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Consumer<MotorProvider>(
                  builder: (context, provider, _) => Row(
                    children: [
                      _buildCategoryChip(
                        context,
                        label: 'Semua',
                        icon: Icons.all_inclusive,
                        selected: provider.selectedCategory == 'Semua',
                        onTap: () {
                          provider.setCategory('Semua');
                          onNavigateToTab(1);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildCategoryChip(
                        context,
                        label: 'Matic',
                        icon: Icons.electric_scooter,
                        selected: provider.selectedCategory == 'Matic',
                        onTap: () {
                          provider.setCategory('Matic');
                          onNavigateToTab(1);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildCategoryChip(
                        context,
                        label: 'Sport',
                        icon: Icons.sports_motorsports,
                        selected: provider.selectedCategory == 'Sport',
                        onTap: () {
                          provider.setCategory('Sport');
                          onNavigateToTab(1);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildCategoryChip(
                        context,
                        label: 'Retro',
                        icon: Icons.moped,
                        selected: provider.selectedCategory == 'Retro',
                        onTap: () {
                          provider.setCategory('Retro');
                          onNavigateToTab(1);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Rekomendasi Unggulan Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rekomendasi Terpopuler',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Consumer<MotorProvider>(
                      builder: (context, provider, _) => Text(
                        '(${provider.recommendedMotors.length} Motor)',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Rekomendasi List
              Consumer<MotorProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (provider.errorMessage.isNotEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          provider.errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  final recommendations = provider.recommendedMotors;
                  if (recommendations.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: Text('Belum ada motor rekomendasi.')),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recommendations.length,
                    itemBuilder: (context, index) {
                      final motor = recommendations[index];
                      return MotorCardWidget(
                        motor: motor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MotorDetailScreen(motor: motor),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(icon, size: 18, color: color),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? Colors.deepOrange : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? Colors.deepOrange : Colors.grey.shade300,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? Colors.white : Colors.grey.shade700,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
