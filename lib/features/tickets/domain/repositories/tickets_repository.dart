import '../entities/ticket.dart';

abstract class TicketsRepository {
  Future<List<Ticket>> getTickets();
  Future<Ticket> createTicket(String title, String description);
  Future<Ticket> updateTicketStatus(String id, TicketStatus status);
  Future<List<Ticket>> syncTicketsFromApi();
}
