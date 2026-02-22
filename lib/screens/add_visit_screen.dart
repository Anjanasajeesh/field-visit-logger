import 'dart:io';
import 'package:field_visit_logger/db/visit_db.dart';
import 'package:field_visit_logger/models/visit_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class AddVisitScreen extends StatefulWidget {
  const AddVisitScreen({super.key});

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  final _formKey = GlobalKey<FormState>();

  final farmerController = TextEditingController();
  final villageController = TextEditingController();
  final notesController = TextEditingController();

  String selectedCrop = 'Rice';

  File? imageFile;
  double? latitude;
  double? longitude;

  final List<String> cropTypes = [
    'Rice',
    'Wheat',
    'Coconut',
    'Banana',
    'Vegetables',
  ];

  Future<void> captureImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future<void> fetchLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied')),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  Future<void> saveVisit() async {
    if (!_formKey.currentState!.validate()) return;

    if (imageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please capture a photo')));
      return;
    }

    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fetch GPS location')),
      );
      return;
    }

    final visit = Visit(
      farmerName: farmerController.text.trim(),
      village: villageController.text.trim(),
      cropType: selectedCrop,
      notes: notesController.text.trim(),
      imagePath: imageFile!.path,
      latitude: latitude!,
      longitude: longitude!,
      dateTime: DateTime.now().toString(),
      isSynced: false,
    );

    await VisitDatabase.instance.insertVisit(visit);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Visit')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: farmerController,
                decoration: const InputDecoration(labelText: 'Farmer Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: villageController,
                decoration: const InputDecoration(labelText: 'Village'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedCrop,
                decoration: const InputDecoration(labelText: 'Crop Type'),
                items: cropTypes
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => selectedCrop = v!),
              ),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: captureImage,
                child: const Text('Capture Photo'),
              ),
              if (imageFile != null) ...[
                const SizedBox(height: 8),
                Image.file(imageFile!, height: 160),
              ],

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: fetchLocation,
                child: const Text('Fetch GPS Location'),
              ),
              if (latitude != null && longitude != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Location: $latitude , $longitude',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: saveVisit,
                child: const Text('Save Visit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
