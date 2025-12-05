import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../models/ticket_model.dart';
import '../../domain/entities/ticket.dart';

abstract class TicketsRemoteDataSource {
  Future<List<TicketModel>> fetchTicketsFromApi();
}

class TicketsRemoteDataSourceImpl implements TicketsRemoteDataSource {
  final DioClient dioClient;

  TicketsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<TicketModel>> fetchTicketsFromApi() async {
    try {
      final Response response = await dioClient.dio.get('/posts');
      final List data = response.data as List;

      // Just first 10 posts par exemple
      final subset = data.take(10).toList();

      return subset.map((item) {
        final map = item as Map<String, dynamic>;
        return TicketModel(
          id: map['id'].toString(),
          title: map['title'] as String,
          description: (map['body'] as String?) ?? '',
          status: TicketStatus.open,
          createdAt: DateTime.now(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Network error while fetching tickets');
    }
  }
}
