import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rental_booking_model.dart';
import '../providers/rental_provider.dart';
import '../widgets/rental_card_widget.dart';
import 'add_rental_screen.dart';
import 'edit_rental_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const FavoritesScreen({
    super.key,
    this.onNavigateToTab,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _filterType = 'Semua';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RentalProvider>(context, listen: false).loadBookings();
    });
  }

  void _showDeleteConfirmation(
      BuildContext context, RentalProvider provider, RentalBookingModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Batalkan Sewa'),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus data booking "${item.motorName}" atas nama ${item.customerName} dari database?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              if (item.id != null) {
                final success =
                    await provider.removeBooking(item.id!, item.motorId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success
                          ? 'Booking "${item.motorName}" berhasil dihapus.'
                          : 'Gagal menghapus data booking.'),
                      backgroundColor:
                          success ? Colors.grey[800] : Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Rental (Database SQLite)'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Tambah Sewa Manual',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddRentalScreen(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRentalScreen(),
            ),
          );
        },
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Catat Sewa Baru'),
      ),
      body: Consumer<RentalProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 60, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      provider.errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => provider.loadBookings(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final allItems = provider.bookings;
          final items = _filterType == 'Semua'
              ? allItems
              : allItems.where((k) => k.type == _filterType).toList();

          if (allItems.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.two_wheeler,
                        size: 72, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum Ada Booking Motor',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pilih unit motor dari katalog rental atau buat catatan sewa baru secara manual ke database SQLite.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    if (widget.onNavigateToTab != null)
                      ElevatedButton.icon(
                        onPressed: () => widget.onNavigateToTab!(1),
                        icon: const Icon(Icons.search),
                        label: const Text('Buka Katalog Motor'),
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

          return RefreshIndicator(
            onRefresh: () => provider.loadBookings(),
            child: Column(
              children: [
                // Info Bar & Filter Dropdown
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.grey.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Booking: ${allItems.length} Data',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      DropdownButton<String>(
                        value: _filterType,
                        underline: const SizedBox(),
                        style: const TextStyle(
                            fontSize: 13, color: Colors.deepOrange),
                        items: const [
                          DropdownMenuItem(
                              value: 'Semua', child: Text('Semua Tipe')),
                          DropdownMenuItem(
                              value: 'Matic', child: Text('Matic')),
                          DropdownMenuItem(
                              value: 'Sport', child: Text('Sport')),
                          DropdownMenuItem(
                              value: 'Retro', child: Text('Retro')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _filterType = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return RentalCardWidget(
                        item: item,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditRentalScreen(item: item),
                            ),
                          );
                        },
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditRentalScreen(item: item),
                            ),
                          );
                        },
                        onDelete: () =>
                            _showDeleteConfirmation(context, provider, item),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
