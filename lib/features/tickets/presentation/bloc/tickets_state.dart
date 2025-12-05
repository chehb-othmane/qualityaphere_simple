import 'package:equatable/equatable.dart';
import '../../domain/entities/ticket.dart';

class TicketsState extends Equatable {
  final bool isLoading;
  final List<Ticket> tickets;
  final String? error;

  const TicketsState({
    this.isLoading = false,
    this.tickets = const [],
    this.error,
  });

  TicketsState copyWith({
    bool? isLoading,
    List<Ticket>? tickets,
    String? error,
  }) {
    return TicketsState(
      isLoading: isLoading ?? this.isLoading,
      tickets: tickets ?? this.tickets,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, tickets, error];
}
