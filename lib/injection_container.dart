import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/register.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

import 'features/tickets/domain/usecases/watch_tickets.dart';
import 'features/tickets/data/datasources/tickets_remote_data_source.dart';
import 'features/tickets/data/repositories/tickets_repository_impl.dart';
import 'features/tickets/domain/repositories/tickets_repository.dart';
import 'features/tickets/domain/usecases/create_ticket.dart';
import 'features/tickets/domain/usecases/update_ticket_status.dart';
import 'features/tickets/presentation/bloc/tickets_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --------------------
  // External
  // --------------------
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // ✅ FirebaseFirestore REGISTERED ONCE
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // --------------------
  // Auth
  // --------------------
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      getCurrentUserUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  // --------------------
  // Tickets (REALTIME – FIRESTORE)
  // --------------------
  sl.registerLazySingleton<TicketsRemoteDataSource>(
    () => TicketsRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<TicketsRepository>(
    () => TicketsRepositoryImpl(remote: sl()),
  );

  sl.registerLazySingleton(() => WatchTickets(sl()));
  sl.registerLazySingleton(() => CreateTicket(sl()));
  sl.registerLazySingleton(() => UpdateTicketStatus(sl()));

  sl.registerFactory(
    () => TicketsBloc(
      watchTickets: sl(),
      createTicketUseCase: sl(),
      updateTicketStatusUseCase: sl(),
    ),
  );
}
