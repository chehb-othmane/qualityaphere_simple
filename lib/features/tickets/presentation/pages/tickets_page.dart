import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/ticket.dart';
import '../bloc/tickets_bloc.dart';
import '../bloc/tickets_event.dart';
import '../bloc/tickets_state.dart';
import 'ticket_form_page.dart';

class TicketsPage extends StatelessWidget {
  final bool showAppBar;
  const TicketsPage({super.key, this.showAppBar = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar(title: const Text('Tickets')) : null,
      body: BlocConsumer<TicketsBloc, TicketsState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.tickets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.tickets.isEmpty) {
            return const Center(child: Text('No tickets yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.tickets.length,
            itemBuilder: (context, index) {
              final ticket = state.tickets[index];
              return Card(
                child: ListTile(
                  title: Text(ticket.title),
                  subtitle: Text(ticket.description),
                  trailing: PopupMenuButton<TicketStatus>(
                    onSelected: (status) {
                      context.read<TicketsBloc>().add(
                        UpdateTicketStatusRequested(
                          id: ticket.id,
                          status: status,
                        ),
                      );
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: TicketStatus.open,
                        child: Text('Open'),
                      ),
                      PopupMenuItem(
                        value: TicketStatus.inProgress,
                        child: Text('In progress'),
                      ),
                      PopupMenuItem(
                        value: TicketStatus.resolved,
                        child: Text('Resolved'),
                      ),
                    ],
                    child: Chip(label: Text(ticket.status.name)),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TicketFormPage()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
