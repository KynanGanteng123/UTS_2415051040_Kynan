import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rental_booking_model.dart';
import '../providers/rental_provider.dart';
import '../widgets/rating_stars_widget.dart';
import '../widgets/custom_button_widget.dart';

class EditRentalScreen extends StatefulWidget {
  final RentalBookingModel item;

  const EditRentalScreen({
    super.key,
    required this.item,
  });

  @override
  State<EditRentalScreen> createState() => _EditRentalScreenState();
}

class _EditRentalScreenState extends State<EditRentalScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _motorNameController;
  late TextEditingController _customerController;
  late TextEditingController _daysController;
  late TextEditingController _priceController;
  late TextEditingController _noteController;

  late String _selectedType;
  late double _rating;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _motorNameController =
        TextEditingController(text: widget.item.motorName);
    _customerController =
        TextEditingController(text: widget.item.customerName);
    _daysController =
        TextEditingController(text: widget.item.rentalDays.toString());
    _priceController =
        TextEditingController(text: widget.item.pricePerDay.toString());
    _noteController = TextEditingController(text: widget.item.note);
    _selectedType = widget.item.type;
    _rating = widget.item.rating;
  }

  @override
  void dispose() {
    _motorNameController.dispose();
    _customerController.dispose();
    _daysController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _updateForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final provider = Provider.of<RentalProvider>(context, listen: false);
    final days = int.tryParse(_daysController.text.trim()) ?? widget.item.rentalDays;
    final pricePerDay =
        int.tryParse(_priceController.text.replaceAll('.', '').trim()) ??
            widget.item.pricePerDay;
    final total = days * pricePerDay;

    final updatedItem = widget.item.copyWith(
      motorName: _motorNameController.text.trim(),
      customerName: _customerController.text.trim(),
      rentalDays: days,
      pricePerDay: pricePerDay,
      totalPrice: total,
      type: _selectedType,
      note: _noteController.text.trim(),
      rating: _rating,
    );

    final success = await provider.editBooking(updatedItem);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data sewa motor berhasil diperbarui di database!'),
            backgroundColor: Colors.teal,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage.isNotEmpty
                ? provider.errorMessage
                : 'Gagal memperbarui data sewa.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Catatan Sewa (Update)'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit_note, color: Colors.amber.shade900),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mengedit Booking ID #${widget.item.id} • Dibuat oleh NIM ${widget.item.studentId}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.brown.shade800),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Unit Motor
              TextFormField(
                controller: _motorNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Unit Motor *',
                  prefixIcon: Icon(Icons.two_wheeler),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nama motor wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Nama Penyewa
              TextFormField(
                controller: _customerController,
                decoration: const InputDecoration(
                  labelText: 'Nama Penyewa *',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nama penyewa wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Harga & Durasi Row
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Tarif / Hari (Rp) *',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Tarif wajib diisi';
                        }
                        if (int.tryParse(val.replaceAll('.', '').trim()) ==
                            null) {
                          return 'Harus angka valid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _daysController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Durasi (Hari) *',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Wajib diisi';
                        }
                        if (int.tryParse(val.trim()) == null ||
                            int.parse(val.trim()) <= 0) {
                          return 'Minimal 1 hari';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Tipe Motor Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Kategori Tipe Motor',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: const [
                  DropdownMenuItem(value: 'Matic', child: Text('Matic')),
                  DropdownMenuItem(value: 'Sport', child: Text('Sport')),
                  DropdownMenuItem(value: 'Retro', child: Text('Retro')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedType = val;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              // Rating
              const Text(
                'Rating Kepuasan (1 - 5 Bintang)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  RatingStarsWidget(
                    rating: _rating,
                    size: 28,
                    isInteractive: true,
                    onRatingChanged: (newRating) {
                      setState(() {
                        _rating = newRating;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$_rating / 5.0',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Catatan
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Catatan Sewa *',
                  prefixIcon: Icon(Icons.note_alt_outlined),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Catatan sewa wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: CustomButtonWidget(
                  label: 'Simpan Perubahan Data',
                  icon: Icons.update,
                  isLoading: _isLoading,
                  color: Colors.deepOrange,
                  onPressed: _updateForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
