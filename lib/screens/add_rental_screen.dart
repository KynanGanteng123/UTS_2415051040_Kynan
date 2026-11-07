import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rental_booking_model.dart';
import '../providers/rental_provider.dart';
import '../widgets/rating_stars_widget.dart';
import '../widgets/custom_button_widget.dart';

class AddRentalScreen extends StatefulWidget {
  const AddRentalScreen({super.key});

  @override
  State<AddRentalScreen> createState() => _AddRentalScreenState();
}

class _AddRentalScreenState extends State<AddRentalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _motorNameController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _daysController = TextEditingController(text: '1');
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _selectedType = 'Matic';
  double _rating = 5.0;
  bool _isLoading = false;

  @override
  void dispose() {
    _motorNameController.dispose();
    _customerController.dispose();
    _daysController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final provider = Provider.of<RentalProvider>(context, listen: false);
    final days = int.tryParse(_daysController.text.trim()) ?? 1;
    final pricePerDay =
        int.tryParse(_priceController.text.replaceAll('.', '').trim()) ?? 0;
    final total = days * pricePerDay;

    final newBooking = RentalBookingModel(
      studentId: '2415051040',
      motorId: DateTime.now().millisecondsSinceEpoch % 100000,
      motorName: _motorNameController.text.trim(),
      customerName: _customerController.text.trim(),
      rentalDays: days,
      pricePerDay: pricePerDay,
      totalPrice: total,
      type: _selectedType,
      note: _noteController.text.trim(),
      rating: _rating,
      createdAt: DateTime.now().toIso8601String(),
    );

    final success = await provider.createBooking(newBooking);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data sewa motor berhasil disimpan ke database SQLite!'),
            backgroundColor: Colors.teal,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage.isNotEmpty
                ? provider.errorMessage
                : 'Gagal menyimpan data sewa.'),
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
        title: const Text('Catat Sewa Motor Baru (Create)'),
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
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.deepOrange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Formulir pencatatan sewa motor manual ke database lokal SQLite MotoRent.',
                        style: TextStyle(fontSize: 12, color: Colors.deepOrange),
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
                  hintText: 'Misal: Honda PCX 160 ABS',
                  prefixIcon: Icon(Icons.two_wheeler),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nama motor wajib diisi';
                  }
                  if (val.trim().length < 3) {
                    return 'Nama motor minimal 3 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Nama Penyewa
              TextFormField(
                controller: _customerController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap Penyewa *',
                  hintText: 'Misal: Kynan / Mahasiswa Undiksha',
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
                        hintText: '85000',
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

              // Rating Kepuasan / Kondisi
              const Text(
                'Rating Kondisi Unit (1 - 5 Bintang)',
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
                  labelText: 'Catatan Sewa (Lokasi Antar, Jaminan, Helm) *',
                  hintText: 'Tuliskan titik temu, permintaan helm, atau jaminan identitas KTP...',
                  prefixIcon: Icon(Icons.note_alt_outlined),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Catatan sewa wajib diisi';
                  }
                  if (val.trim().length < 5) {
                    return 'Catatan minimal 5 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: CustomButtonWidget(
                  label: 'Simpan ke Database SQLite',
                  icon: Icons.save,
                  isLoading: _isLoading,
                  color: Colors.deepOrange,
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
