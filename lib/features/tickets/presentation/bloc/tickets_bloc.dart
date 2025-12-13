import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/ticket.dart';
import '../../domain/usecases/watch_tickets.dart';
import '../../domain/usecases/create_ticket.dart';
import '../../domain/usecases/update_ticket_status.dart';

import 'tickets_event.dart';
import 'tickets_state.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  final WatchTickets watchTickets;
  final CreateTicket createTicketUseCase;
  final UpdateTicketStatus updateTicketStatusUseCase;

  StreamSubscription<List<Ticket>>? _sub;

  TicketsBloc({
    required this.watchTickets,
    required this.createTicketUseCase,
    required this.updateTicketStatusUseCase,
  }) : super(const TicketsState()) {
    on<StartTicketsStream>(_onStartStream);
    on<TicketsUpdated>(_onTicketsUpdated);

    on<CreateTicketRequested>(_onCreateTicket);
    on<UpdateTicketStatusRequested>(_onUpdateStatus);
  }

  void _onStartStream(StartTicketsStream event, Emitter<TicketsState> emit) {
    emit(state.copyWith(isLoading: true, error: null));
    _sub?.cancel();
    _sub = watchTickets().listen(
      (tickets) => add(TicketsUpdated(tickets)),
      onError: (e) => addError(e),
    );
  }

  void _onTicketsUpdated(TicketsUpdated event, Emitter<TicketsState> emit) {
    emit(state.copyWith(isLoading: false, tickets: event.tickets, error: null));
  }

  Future<void> _onCreateTicket(
    CreateTicketRequested event,
    Emitter<TicketsState> emit,
  ) async {
    try {
      await createTicketUseCase(
        CreateTicketParams(title: event.title, description: event.description),
      );
      // No manual reload: stream will update automatically
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdateStatus(
    UpdateTicketStatusRequested event,
    Emitter<TicketsState> emit,
  ) async {
    try {
      await updateTicketStatusUseCase(
        UpdateTicketStatusParams(id: event.id, status: event.status),
      );
      // stream updates automatically
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
