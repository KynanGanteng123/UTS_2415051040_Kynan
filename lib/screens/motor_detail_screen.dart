import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/motor_model.dart';
import '../models/rental_booking_model.dart';
import '../providers/motor_provider.dart';
import '../providers/rental_provider.dart';
import '../widgets/status_badge_widget.dart';
import '../widgets/rating_stars_widget.dart';
import '../widgets/custom_button_widget.dart';
import 'edit_motor_screen.dart';
import 'edit_rental_screen.dart';

class MotorDetailScreen extends StatelessWidget {
  final MotorModel motor;

  const MotorDetailScreen({
    super.key,
    required this.motor,
  });

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'matic':
        return Colors.blue;
      case 'sport':
        return Colors.red;
      case 'retro':
        return Colors.orange;
      default:
        return Colors.teal;
    }
  }

  void _confirmDeleteMotor(BuildContext context, MotorModel currentMotor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Hapus Unit Motor?'),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus unit "${currentMotor.name}" dari katalog rental dan database SQLite?',
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
              final provider =
                  Provider.of<MotorProvider>(context, listen: false);
              final success = await provider.deleteMotor(currentMotor.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Unit motor "${currentMotor.name}" berhasil dihapus!'
                        : 'Gagal menghapus unit motor.'),
                    backgroundColor: success ? Colors.teal : Colors.red,
                  ),
                );
                if (success) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Ya, Hapus'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context, MotorModel currentMotor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.phone_forwarded, color: Colors.deepOrange),
            SizedBox(width: 8),
            Text('Hubungi MotoRent'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentMotor.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            const Text(
              'Customer Service: 0812-3456-7840',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 6),
            const Text(
              'Lokasi Garasi: Jl. Udayana No. 40, Singaraja, Bali',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const Text(
              'Persyaratan sewa: KTP Asli + SIM C aktif + uang deposit / jaminan identitas.',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Menghubungkan ke WhatsApp MotoRent Singaraja...'),
                  backgroundColor: Colors.teal,
                ),
              );
            },
            icon: const Icon(Icons.chat),
            label: const Text('Hubungi via WhatsApp'),
          ),
        ],
      ),
    );
  }

  void _showBookingBottomSheet(BuildContext context, MotorModel currentMotor) {
    final customerController = TextEditingController(text: 'Kynan');
    final noteController = TextEditingController();
    int rentalDays = 2;
    double currentRating = 5.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          final totalCost = currentMotor.pricePerDay * rentalDays;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Form Booking Sewa Motor',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                Text(
                  'Unit: ${currentMotor.name} (${currentMotor.formattedPrice})',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepOrange),
                ),
                const SizedBox(height: 14),

                // Nama Penyewa
                TextField(
                  controller: customerController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap Penyewa *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),

                const SizedBox(height: 12),

                // Durasi Hari
                Row(
                  children: [
                    const Text('Durasi Sewa: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: rentalDays > 1
                          ? () {
                              setSheetState(() {
                                rentalDays--;
                              });
                            }
                          : null,
                    ),
                    Text(
                      '$rentalDays Hari',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setSheetState(() {
                          rentalDays++;
                        });
                      },
                    ),
                    const Spacer(),
                    Text(
                      'Total: Rp $totalCost',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Rating
                Row(
                  children: [
                    const Text('Beri Rating: ',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    RatingStarsWidget(
                      rating: currentRating,
                      size: 22,
                      isInteractive: true,
                      onRatingChanged: (newRating) {
                        setSheetState(() {
                          currentRating = newRating;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Text('$currentRating',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),

                const SizedBox(height: 12),

                // Catatan / Permintaan Khusus
                TextField(
                  controller: noteController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Catatan Sewa (Titik Antar, Helm, dll)',
                    hintText: 'Misal: Antar ke kampus Undiksha jam 08.00 pagi.',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                // Tombol Simpan Booking
                SizedBox(
                  width: double.infinity,
                  child: CustomButtonWidget(
                    label: 'Konfirmasi Booking ke Database SQLite',
                    icon: Icons.check_circle,
                    onPressed: () async {
                      final provider =
                          Provider.of<RentalProvider>(context, listen: false);
                      final newBooking = RentalBookingModel(
                        studentId: '2415051040',
                        motorId: currentMotor.id,
                        motorName: currentMotor.name,
                        customerName: customerController.text.trim().isEmpty
                            ? 'Kynan'
                            : customerController.text.trim(),
                        rentalDays: rentalDays,
                        pricePerDay: currentMotor.pricePerDay,
                        totalPrice: totalCost,
                        type: currentMotor.type,
                        note: noteController.text.trim().isEmpty
                            ? 'Sewa motor $rentalDays hari.'
                            : noteController.text.trim(),
                        rating: currentRating,
                        createdAt: DateTime.now().toIso8601String(),
                      );

                      final success =
                          await provider.createBooking(newBooking);
                      if (ctx.mounted) Navigator.pop(ctx);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success
                                ? 'Berhasil memesan ${currentMotor.name}!'
                                : 'Gagal menyimpan booking.'),
                            backgroundColor:
                                success ? Colors.teal : Colors.redAccent,
                          ),
                        );
                      }
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

  @override
  Widget build(BuildContext context) {
    return Consumer<MotorProvider>(
      builder: (context, motorProvider, _) {
        // Ambil data motor terbaru jika baru saja diedit
        final currentMotor = motorProvider.motors.firstWhere(
          (m) => m.id == motor.id,
          orElse: () => motor,
        );

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Collapsible Image Header with Badges
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        currentMotor.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: Icon(Icons.two_wheeler,
                                size: 64, color: Colors.grey),
                          ),
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black45,
                              Colors.transparent,
                              Colors.black87,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                StatusBadgeWidget(
                                  text: currentMotor.type,
                                  color: _getTypeColor(currentMotor.type),
                                ),
                                const SizedBox(width: 8),
                                StatusBadgeWidget(
                                  text: currentMotor.isAvailable
                                      ? 'Unit Tersedia'
                                      : 'Disewa',
                                  color: currentMotor.isAvailable
                                      ? Colors.green
                                      : Colors.red,
                                  icon: currentMotor.isAvailable
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              currentMotor.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(blurRadius: 4, color: Colors.black),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  // Tombol Edit Motor
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    tooltip: 'Edit Kolom Motor',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditMotorScreen(motor: currentMotor),
                        ),
                      );
                    },
                  ),
                  // Tombol Hapus Motor
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    tooltip: 'Hapus Unit Motor',
                    onPressed: () =>
                        _confirmDeleteMotor(context, currentMotor),
                  ),
                  // Tombol Simpan Booking
                  Consumer<RentalProvider>(
                    builder: (context, rentalProvider, _) {
                      final isBooked = rentalProvider.isBooked(currentMotor.id);
                      return IconButton(
                        icon: Icon(
                          isBooked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBooked ? Colors.amberAccent : Colors.white,
                        ),
                        tooltip: isBooked ? 'Hapus Booking' : 'Booking Motor',
                        onPressed: () async {
                          if (isBooked) {
                            final success =
                                await rentalProvider.toggleBooking(currentMotor);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success
                                      ? 'Motor dihapus dari booking tersimpan.'
                                      : 'Gagal memperbarui status.'),
                                ),
                              );
                            }
                          } else {
                            _showBookingBottomSheet(context, currentMotor);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),

              // Details Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price and Rating Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tarif Sewa Harian',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                currentMotor.formattedPrice,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.amber.shade300),
                            ),
                            child: Row(
                              children: [
                                RatingStarsWidget(
                                    rating: currentMotor.rating, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  '${currentMotor.rating}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),

                      // Spesifikasi Motor
                      const Text(
                        'Spesifikasi Motor',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSpecCard(
                              icon: Icons.speed,
                              title: 'Kapasitas Mesin',
                              value: '${currentMotor.cc} cc',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildSpecCard(
                              icon: Icons.settings,
                              title: 'Transmisi',
                              value: currentMotor.transmission,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildSpecCard(
                              icon: Icons.branding_watermark,
                              title: 'Merk Motor',
                              value: currentMotor.brand,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Fasilitas Rental Termasuk
                      const Text(
                        'Fasilitas Sewa Gratis',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: currentMotor.facilities.map((f) {
                          return Chip(
                            avatar: const Icon(Icons.check_circle_outline,
                                size: 16, color: Colors.teal),
                            label: Text(f),
                            backgroundColor: Colors.teal.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.teal.shade200),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // Deskripsi Unit Motor
                      const Text(
                        'Keterangan & Kondisi Unit',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentMotor.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Shortcut Edit Unit Motor
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.tune, color: Colors.orange),
                                SizedBox(width: 8),
                                Text(
                                  'Kelola Data Motor Ini',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.deepOrange,
                                side: const BorderSide(color: Colors.deepOrange),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditMotorScreen(motor: currentMotor),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit, size: 16),
                              label: const Text('Edit Kolom Motor'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Status Booking di Database jika sudah dibooking
                      Consumer<RentalProvider>(
                        builder: (context, rentalProvider, _) {
                          final isBooked =
                              rentalProvider.isBooked(currentMotor.id);
                          if (!isBooked) return const SizedBox.shrink();

                          final bookingItem = rentalProvider.bookings.firstWhere(
                              (element) => element.motorId == currentMotor.id);

                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.bookmark_added,
                                            color: Colors.deepOrange),
                                        SizedBox(width: 6),
                                        Text(
                                          'Sudah Ada di Daftar Booking DB',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepOrange),
                                        ),
                                      ],
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditRentalScreen(
                                                    item: bookingItem),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit, size: 16),
                                      label: const Text('Edit Sewa'),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Penyewa: ${bookingItem.customerName} (${bookingItem.rentalDays} hari) • Catatan: "${bookingItem.note}"',
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Action Buttons Bottom
                      Row(
                        children: [
                          Expanded(
                            child: CustomButtonWidget(
                              label: 'Hubungi Rental',
                              icon: Icons.chat,
                              color: Colors.teal,
                              onPressed: () =>
                                  _showContactDialog(context, currentMotor),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Consumer<RentalProvider>(
                              builder: (context, rentalProvider, _) {
                                final isBooked =
                                    rentalProvider.isBooked(currentMotor.id);
                                return CustomButtonWidget(
                                  label: isBooked
                                      ? 'Sudah Dibooking'
                                      : 'Pesan Sekarang',
                                  icon: isBooked
                                      ? Icons.check
                                      : Icons.add_shopping_cart,
                                  color: isBooked
                                      ? Colors.grey.shade700
                                      : Colors.deepOrange,
                                  onPressed: () {
                                    if (isBooked) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Motor ini sudah ada dalam daftar booking database Anda.'),
                                        ),
                                      );
                                    } else {
                                      _showBookingBottomSheet(
                                          context, currentMotor);
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpecCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: Colors.deepOrange),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
