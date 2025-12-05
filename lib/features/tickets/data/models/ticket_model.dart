import '../../domain/entities/ticket.dart';

class TicketModel extends Ticket {
  TicketModel({
    required super.id,
    required super.title,
    required super.description,
    required super.status,
    required super.createdAt,
  });

  factory TicketModel.fromMap(Map<dynamic, dynamic> map) {
    return TicketModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      status: _statusFromString(map['status'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name, // open / inProgress / resolved
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static TicketStatus _statusFromString(String value) {
    switch (value) {
      case 'inProgress':
        return TicketStatus.inProgress;
      case 'resolved':
        return TicketStatus.resolved;
      case 'open':
      default:
        return TicketStatus.open;
    }
  }
}
