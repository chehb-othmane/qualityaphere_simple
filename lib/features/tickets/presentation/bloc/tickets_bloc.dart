import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_tickets.dart';
import '../../domain/usecases/create_ticket.dart';
import '../../domain/usecases/update_ticket_status.dart';
import '../../domain/usecases/sync_tickets.dart';
import 'tickets_event.dart';
import 'tickets_state.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  final GetTickets getTicketsUseCase;
  final CreateTicket createTicketUseCase;
  final UpdateTicketStatus updateTicketStatusUseCase;
  final SyncTickets syncTicketsUseCase;

  TicketsBloc({
    required this.getTicketsUseCase,
    required this.createTicketUseCase,
    required this.updateTicketStatusUseCase,
    required this.syncTicketsUseCase,
  }) : super(const TicketsState()) {
    on<LoadTickets>(_onLoadTickets);
    on<CreateTicketRequested>(_onCreateTicketRequested);
    on<UpdateTicketStatusRequested>(_onUpdateTicketStatusRequested);
    on<SyncTicketsRequested>(_onSyncTicketsRequested);
  }

  Future<void> _onLoadTickets(
    LoadTickets event,
    Emitter<TicketsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final tickets = await getTicketsUseCase(NoParams());
      emit(state.copyWith(isLoading: false, tickets: tickets));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onCreateTicketRequested(
    CreateTicketRequested event,
    Emitter<TicketsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final newTicket = await createTicketUseCase(
        CreateTicketParams(title: event.title, description: event.description),
      );
      final updated = List.of(state.tickets)..add(newTicket);
      emit(state.copyWith(isLoading: false, tickets: updated));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateTicketStatusRequested(
    UpdateTicketStatusRequested event,
    Emitter<TicketsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final updatedTicket = await updateTicketStatusUseCase(
        UpdateTicketStatusParams(id: event.id, status: event.status),
      );
      final updatedList = state.tickets
          .map((t) => t.id == updatedTicket.id ? updatedTicket : t)
          .toList();
      emit(state.copyWith(isLoading: false, tickets: updatedList));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onSyncTicketsRequested(
    SyncTicketsRequested event,
    Emitter<TicketsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final tickets = await syncTicketsUseCase(NoParams());
      emit(state.copyWith(isLoading: false, tickets: tickets));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
