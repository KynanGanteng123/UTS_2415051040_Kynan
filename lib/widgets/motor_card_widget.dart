import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/motor_model.dart';
import '../providers/rental_provider.dart';
import '../screens/edit_motor_screen.dart';
import 'status_badge_widget.dart';
import 'rating_stars_widget.dart';

class MotorCardWidget extends StatelessWidget {
  final MotorModel motor;
  final VoidCallback onTap;

  const MotorCardWidget({
    super.key,
    required this.motor,
    required this.onTap,
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image with Badges & Action buttons (Edit & Booking)
            Stack(
              children: [
                Image.network(
                  motor.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 140,
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(Icons.two_wheeler,
                          size: 48, color: Colors.grey.shade400),
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 140,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  },
                ),
                // Type & Availability Badges
                Positioned(
                  top: 8,
                  left: 8,
                  child: Row(
                    children: [
                      StatusBadgeWidget(
                        text: motor.type,
                        color: _getTypeColor(motor.type),
                      ),
                      const SizedBox(width: 4),
                      StatusBadgeWidget(
                        text: motor.isAvailable ? 'Tersedia' : 'Disewa',
                        color: motor.isAvailable ? Colors.green : Colors.red,
                        icon: motor.isAvailable
                            ? Icons.check_circle
                            : Icons.cancel,
                      ),
                    ],
                  ),
                ),
                // Action Buttons: Edit & Bookmark
                Positioned(
                  top: 6,
                  right: 6,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol Edit Motor
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 18,
                          tooltip: 'Edit Motor',
                          icon: const Icon(Icons.edit, color: Colors.deepOrange),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditMotorScreen(motor: motor),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Tombol Bookmark / Simpan Booking
                      Consumer<RentalProvider>(
                        builder: (context, rentalProvider, _) {
                          final isBooked = rentalProvider.isBooked(motor.id);
                          return CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white.withValues(alpha: 0.9),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 20,
                              tooltip: isBooked ? 'Hapus Booking' : 'Simpan Booking',
                              icon: Icon(
                                isBooked ? Icons.bookmark : Icons.bookmark_border,
                                color: isBooked
                                    ? Colors.deepOrange
                                    : Colors.grey.shade700,
                              ),
                              onPressed: () async {
                                final success =
                                    await rentalProvider.toggleBooking(motor);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        success
                                            ? (isBooked
                                                ? '${motor.name} dihapus dari daftar rental.'
                                                : '${motor.name} disimpan ke daftar booking rental!')
                                            : 'Gagal memperbarui status rental.',
                                      ),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: isBooked
                                          ? Colors.grey[800]
                                          : Colors.deepOrange,
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Info Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          motor.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      RatingStarsWidget(rating: motor.rating, size: 14),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.speed, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '${motor.cc} cc • ${motor.transmission}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        motor.formattedPrice,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          size: 12, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
