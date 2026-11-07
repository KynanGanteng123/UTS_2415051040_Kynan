import 'package:flutter/material.dart';
import '../models/rental_booking_model.dart';
import 'status_badge_widget.dart';
import 'rating_stars_widget.dart';

class RentalCardWidget extends StatelessWidget {
  final RentalBookingModel item;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RentalCardWidget({
    super.key,
    required this.item,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Type Badge, Motor Name, Action Icons
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusBadgeWidget(
                    text: item.type,
                    color: _getTypeColor(item.type),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.motorName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined,
                        size: 20, color: Colors.orange),
                    tooltip: 'Edit Booking',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        size: 20, color: Colors.red),
                    tooltip: 'Hapus Booking',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    onPressed: onDelete,
                  ),
                ],
              ),

              const SizedBox(height: 6),
              // Penyewa & Durasi
              Row(
                children: [
                  Icon(Icons.person_pin,
                      size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Penyewa: ${item.customerName} (${item.rentalDays} Hari)',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    item.formattedTotal,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              // Catatan Box
              if (item.note.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.note_alt_outlined,
                          size: 16, color: Colors.deepOrange),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.note,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.brown.shade900,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Footer: Rating & NIM
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Rating: ',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      RatingStarsWidget(rating: item.rating, size: 14),
                    ],
                  ),
                  Text(
                    'NIM: ${item.studentId}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
