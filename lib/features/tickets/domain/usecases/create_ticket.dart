import '../../../../core/usecases/usecase.dart';
import '../entities/ticket.dart';
import '../repositories/tickets_repository.dart';

class CreateTicket implements UseCase<Ticket, CreateTicketParams> {
  final TicketsRepository repository;

  CreateTicket(this.repository);

  @override
  Future<Ticket> call(CreateTicketParams params) {
    return repository.createTicket(params.title, params.description);
  }
}

class CreateTicketParams {
  final String title;
  final String description;

  CreateTicketParams({required this.title, required this.description});
}
