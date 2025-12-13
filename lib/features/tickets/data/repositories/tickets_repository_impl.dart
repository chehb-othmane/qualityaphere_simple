import '../../domain/entities/ticket.dart';
import '../../domain/repositories/tickets_repository.dart';
import '../datasources/tickets_remote_data_source.dart';

class TicketsRepositoryImpl implements TicketsRepository {
  final TicketsRemoteDataSource remote;

  TicketsRepositoryImpl({required this.remote});

  @override
  Stream<List<Ticket>> watchTickets() {
    return remote.watchTickets();
  }

  @override
  Future<Ticket> createTicket(String title, String description) {
    return remote.createTicket(title, description);
  }

  @override
  Future<Ticket> updateTicketStatus(String id, TicketStatus status) {
    return remote.updateTicketStatus(id, status);
  }
}
