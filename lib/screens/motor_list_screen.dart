import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/motor_model.dart';
import '../providers/motor_provider.dart';
import '../widgets/motor_card_widget.dart';
import 'motor_detail_screen.dart';

class MotorListScreen extends StatefulWidget {
  const MotorListScreen({super.key});

  @override
  State<MotorListScreen> createState() => _MotorListScreenState();
}

class _MotorListScreenState extends State<MotorListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MotorProvider>(context, listen: false);
      if (provider.motors.isEmpty) {
        provider.fetchMotors();
      }
      _searchController.text = provider.searchQuery;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Rental Motor'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Consumer<MotorProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari merk, tipe motor, CC, fasilitas...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              provider.setSearchQuery('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onChanged: (val) {
                    provider.setSearchQuery(val);
                    setState(() {});
                  },
                ),
              ),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    _buildFilterChip(provider, 'Semua'),
                    const SizedBox(width: 8),
                    _buildFilterChip(provider, 'Matic'),
                    const SizedBox(width: 8),
                    _buildFilterChip(provider, 'Sport'),
                    const SizedBox(width: 8),
                    _buildFilterChip(provider, 'Retro'),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Responsive List / Grid Main Body
              Expanded(
                child: _buildBodyContent(context, provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(MotorProvider provider, String category) {
    final isSelected = provider.selectedCategory == category;
    return FilterChip(
      label: Text(category),
      selected: isSelected,
      onSelected: (_) => provider.setCategory(category),
      selectedColor: Colors.orange.shade100,
      checkmarkColor: Colors.deepOrange,
      labelStyle: TextStyle(
        color: isSelected ? Colors.deepOrange.shade900 : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context, MotorProvider provider) {
    // 1. Loading State
    if (provider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.deepOrange),
            SizedBox(height: 14),
            Text(
              'Mengambil data motor dari REST API...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // 2. Error State
    if (provider.errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text(
                'Gagal Mengambil Data',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                provider.errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => provider.fetchMotors(),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final items = provider.filteredMotors;

    // 3. Empty State
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text(
                'Motor Tidak Ditemukan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Tidak ada unit motor yang cocok dengan kategori "${provider.selectedCategory}" atau pencarian "${provider.searchQuery}".',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () {
                  _searchController.clear();
                  provider.clearSearch();
                  setState(() {});
                },
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset Filter'),
              ),
            ],
          ),
        ),
      );
    }

    // 4. Data State: Responsive Layout (Compact: List; Wide: Grid)
    return RefreshIndicator(
      onRefresh: () => provider.fetchMotors(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Wide / Expanded layout (> 600px)
          if (constraints.maxWidth > 600) {
            final int crossAxisCount = constraints.maxWidth > 900 ? 3 : 2;
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final motor = items[index];
                return MotorCardWidget(
                  motor: motor,
                  onTap: () => _navigateToDetail(context, motor),
                );
              },
            );
          }

          // Compact layout (<= 600px)
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final motor = items[index];
              return MotorCardWidget(
                motor: motor,
                onTap: () => _navigateToDetail(context, motor),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToDetail(BuildContext context, MotorModel motor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MotorDetailScreen(motor: motor),
      ),
    );
  }
}
