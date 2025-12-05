import 'package:hive_flutter/hive_flutter.dart';

import '../models/ticket_model.dart';
import '../../domain/entities/ticket.dart';

abstract class TicketsLocalDataSource {
  Future<List<TicketModel>> getTickets();
  Future<void> saveTickets(List<TicketModel> tickets);
  Future<TicketModel> createTicket(String title, String description);
  Future<TicketModel> updateTicketStatus(String id, TicketStatus status);
}

class TicketsLocalDataSourceImpl implements TicketsLocalDataSource {
  static const String ticketsBoxName = 'tickets_box';

  Box get _box => Hive.box(ticketsBoxName);

  @override
  Future<List<TicketModel>> getTickets() async {
    final values = _box.values.cast<Map>().toList();
    return values
        .map((map) => TicketModel.fromMap(map.cast<dynamic, dynamic>()))
        .toList();
  }

  @override
  Future<void> saveTickets(List<TicketModel> tickets) async {
    await _box.clear();
    for (final ticket in tickets) {
      await _box.put(ticket.id, ticket.toMap());
    }
  }

  @override
  Future<TicketModel> createTicket(String title, String description) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final ticket = TicketModel(
      id: id,
      title: title,
      description: description,
      status: TicketStatus.open,
      createdAt: DateTime.now(),
    );
    await _box.put(id, ticket.toMap());
    return ticket;
  }

  @override
  Future<TicketModel> updateTicketStatus(String id, TicketStatus status) async {
    final map = _box.get(id) as Map?;
    if (map == null) {
      throw Exception('Ticket not found');
    }
    final updated = TicketModel.fromMap(
      map,
    ).copyWithStatus(status); // see extension below
    await _box.put(id, updated.toMap());
    return updated;
  }
}

extension TicketModelCopy on TicketModel {
  TicketModel copyWithStatus(TicketStatus status) {
    return TicketModel(
      id: id,
      title: title,
      description: description,
      status: status,
      createdAt: createdAt,
    );
  }
}
