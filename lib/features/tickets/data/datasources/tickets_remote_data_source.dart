import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ticket_model.dart';
import '../../domain/entities/ticket.dart';

abstract class TicketsRemoteDataSource {
  Stream<List<TicketModel>> watchTickets();
  Future<TicketModel> createTicket(String title, String description);
  Future<TicketModel> updateTicketStatus(String id, TicketStatus status);
}

class TicketsRemoteDataSourceImpl implements TicketsRemoteDataSource {
  final FirebaseFirestore firestore;

  TicketsRemoteDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _col =>
      firestore.collection('tickets');

  TicketStatus _statusFromString(String value) {
    switch (value) {
      case 'inProgress':
        return TicketStatus.inProgress;
      case 'resolved':
        return TicketStatus.resolved;
      default:
        return TicketStatus.open;
    }
  }

  @override
  Stream<List<TicketModel>> watchTickets() {
    return _col.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        final createdAtField = data['createdAt'];
        final createdAt = createdAtField is Timestamp
            ? createdAtField.toDate()
            : DateTime.now();

        return TicketModel(
          id: doc.id,
          title: data['title'] ?? 'Untitled',
          description: data['description'] ?? '',
          status: _statusFromString(data['status'] ?? 'open'),
          createdAt: createdAt,
        );
      }).toList();
    });
  }

  @override
  Future<TicketModel> createTicket(String title, String description) async {
    final doc = await _col.add({
      'title': title,
      'description': description,
      'status': TicketStatus.open.name,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final snap = await doc.get();
    final data = snap.data()!;
    return TicketModel(
      id: snap.id,
      title: data['title'],
      description: data['description'],
      status: TicketStatus.open,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<TicketModel> updateTicketStatus(String id, TicketStatus status) async {
    await _col.doc(id).update({'status': status.name});
    final snap = await _col.doc(id).get();
    final data = snap.data()!;
    return TicketModel(
      id: snap.id,
      title: data['title'],
      description: data['description'],
      status: _statusFromString(data['status']),
      createdAt: DateTime.now(),
    );
  }
}
