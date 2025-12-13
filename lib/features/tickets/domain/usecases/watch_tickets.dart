import '../entities/ticket.dart';
import '../repositories/tickets_repository.dart';

class WatchTickets {
  final TicketsRepository repository;
  WatchTickets(this.repository);

  Stream<List<Ticket>> call() {
    return repository.watchTickets();
  }
}
