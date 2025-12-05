import '../../../../core/usecases/usecase.dart';
import '../entities/ticket.dart';
import '../repositories/tickets_repository.dart';

class UpdateTicketStatus implements UseCase<Ticket, UpdateTicketStatusParams> {
  final TicketsRepository repository;

  UpdateTicketStatus(this.repository);

  @override
  Future<Ticket> call(UpdateTicketStatusParams params) {
    return repository.updateTicketStatus(params.id, params.status);
  }
}

class UpdateTicketStatusParams {
  final String id;
  final TicketStatus status;

  UpdateTicketStatusParams({required this.id, required this.status});
}
