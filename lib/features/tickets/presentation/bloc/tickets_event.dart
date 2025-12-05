import 'package:equatable/equatable.dart';
import '../../domain/entities/ticket.dart';

abstract class TicketsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTickets extends TicketsEvent {}

class CreateTicketRequested extends TicketsEvent {
  final String title;
  final String description;

  CreateTicketRequested({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}

class UpdateTicketStatusRequested extends TicketsEvent {
  final String id;
  final TicketStatus status;

  UpdateTicketStatusRequested({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status];
}

class SyncTicketsRequested extends TicketsEvent {}
