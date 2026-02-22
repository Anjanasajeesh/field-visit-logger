import 'dart:io';
import 'package:field_visit_logger/db/visit_db.dart';
import 'package:field_visit_logger/models/visit_model.dart';
import 'package:field_visit_logger/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'add_visit_screen.dart';
import 'visit_detail_screen.dart';

class VisitListScreen extends StatefulWidget {
  const VisitListScreen({super.key});

  @override
  State<VisitListScreen> createState() => _VisitListScreenState();
}

class _VisitListScreenState extends State<VisitListScreen> {
  List<Visit> visits = [];

  void loadVisits() async {
    visits = await VisitDatabase.instance.getVisits();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    SyncService.instance.startAutoSync();
    loadVisits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visit List')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddVisitScreen()),
          );
          loadVisits();
        },
      ),
      body: ListView.builder(
        itemCount: visits.length,
        itemBuilder: (_, i) {
          final v = visits[i];
          return ListTile(
            leading: Image.file(
              File(v.imagePath),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(v.farmerName),
            subtitle: Text('${v.village} • ${v.cropType}'),
            trailing: Text(
              v.isSynced ? 'Synced' : 'Pending',
              style: TextStyle(color: v.isSynced ? Colors.green : Colors.red),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VisitDetailScreen(visit: v)),
              );
            },
          );
        },
      ),
    );
  }
}
