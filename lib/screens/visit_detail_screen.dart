import 'dart:io';
import 'package:field_visit_logger/models/visit_model.dart';
import 'package:flutter/material.dart';

class VisitDetailScreen extends StatelessWidget {
  final Visit visit;
  const VisitDetailScreen({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visit Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Image.file(File(visit.imagePath)),
            Text('Farmer Name: ${visit.farmerName}'),
            Text('Village: ${visit.village}'),
            Text('Crop Type: ${visit.cropType}'),
            Text('Notes: ${visit.notes}'),
            Text('Visit Date: ${visit.dateTime}'),
            Text('GPS Location: ${visit.latitude}, ${visit.longitude}'),
            Text('Sync Status: ${visit.isSynced ? "Synced" : "Pending"}'),
          ],
        ),
      ),
    );
  }
}
