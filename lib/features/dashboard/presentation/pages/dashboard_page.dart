import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../tickets/presentation/bloc/tickets_bloc.dart';
import '../../../tickets/presentation/bloc/tickets_state.dart';
import '../../../tickets/presentation/bloc/tickets_event.dart';
import '../../../tickets/presentation/pages/tickets_page.dart';
import '../../../tickets/presentation/pages/ticket_form_page.dart';
import '../../../tickets/domain/entities/ticket.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [
      _DashboardHome(),
      _DashboardTickets(),
      _DashboardProfile(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _DashboardHome extends StatelessWidget {
  const _DashboardHome();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketsBloc, TicketsState>(
      builder: (context, state) {
        final tickets = state.tickets;
        final open = tickets.where((t) => t.status == TicketStatus.open).length;
        final inProgress = tickets
            .where((t) => t.status == TicketStatus.inProgress)
            .length;
        final resolved = tickets
            .where((t) => t.status == TicketStatus.resolved)
            .length;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _StatCard(label: 'Open', value: open.toString()),
                  const SizedBox(width: 8),
                  _StatCard(label: 'In progress', value: inProgress.toString()),
                  const SizedBox(width: 8),
                  _StatCard(label: 'Resolved', value: resolved.toString()),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<TicketsBloc>().add(SyncTicketsRequested());
                },
                icon: const Icon(Icons.cloud_download),
                label: const Text('Sync tickets from API'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TicketFormPage()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Create ticket'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardTickets extends StatelessWidget {
  const _DashboardTickets();

  @override
  Widget build(BuildContext context) {
    return const TicketsPage(showAppBar: false);
  }
}

class _DashboardProfile extends StatelessWidget {
  const _DashboardProfile();

  @override
  Widget build(BuildContext context) {
    return const ProfilePage();
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
