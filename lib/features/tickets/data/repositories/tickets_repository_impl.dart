import '../../../../core/error/failures.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/repositories/tickets_repository.dart';
import '../datasources/tickets_local_data_source.dart';
import '../datasources/tickets_remote_data_source.dart';
import '../models/ticket_model.dart';

class TicketsRepositoryImpl implements TicketsRepository {
  final TicketsLocalDataSource localDataSource;
  final TicketsRemoteDataSource remoteDataSource;

  TicketsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<Ticket>> getTickets() async {
    try {
      return await localDataSource.getTickets();
    } catch (e) {
      throw AuthFailure('Error loading tickets: $e');
    }
  }

  @override
  Future<Ticket> createTicket(String title, String description) async {
    try {
      return await localDataSource.createTicket(title, description);
    } catch (e) {
      throw AuthFailure('Error creating ticket: $e');
    }
  }

  @override
  Future<Ticket> updateTicketStatus(String id, TicketStatus status) async {
    try {
      return await localDataSource.updateTicketStatus(id, status);
    } catch (e) {
      throw AuthFailure('Error updating ticket: $e');
    }
  }

  @override
  Future<List<Ticket>> syncTicketsFromApi() async {
    try {
      final List<TicketModel> remote = await remoteDataSource
          .fetchTicketsFromApi();
      await localDataSource.saveTickets(remote);
      return remote;
    } catch (e) {
      throw AuthFailure('Error syncing tickets: $e');
    }
  }
}
