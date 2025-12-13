import '../entities/ticket.dart';

abstract class TicketsRepository {
  Stream<List<Ticket>> watchTickets();
  Future<Ticket> createTicket(String title, String description);
  Future<Ticket> updateTicketStatus(String id, TicketStatus status);
}
