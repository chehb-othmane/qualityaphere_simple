import '../../../../core/usecases/usecase.dart';
import '../entities/ticket.dart';
import '../repositories/tickets_repository.dart';

class GetTickets implements UseCase<List<Ticket>, NoParams> {
  final TicketsRepository repository;

  GetTickets(this.repository);

  @override
  Future<List<Ticket>> call(NoParams params) {
    return repository.getTickets();
  }
}
