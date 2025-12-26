import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'injection_container.dart' as di;
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/tickets/presentation/pages/tickets_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/tickets/presentation/bloc/tickets_bloc.dart';
import 'features/tickets/presentation/bloc/tickets_event.dart';
import 'injection_container.dart';
import 'features/profile/presentation/pages/users_page.dart';

class QualitySphereApp extends StatelessWidget {
  const QualitySphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()..add(AuthStarted())),
        BlocProvider(
          create: (_) => sl<TicketsBloc>()..add(StartTicketsStream()),
        ),
      ],
      child: MaterialApp(
        title: 'QualitySphere',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF135BEC)),
          fontFamily: 'Manrope',
        ),
        debugShowCheckedModeBanner: false,
        home: const _RootPage(),
        routes: {
          '/login': (_) => const LoginPage(),
          '/signup': (_) => const SignupPage(),
          '/dashboard': (_) => const DashboardPage(),
          '/tickets': (_) => const TicketsPage(showAppBar: true),
          '/profile': (_) => const ProfilePage(),
          '/users': (_) => const UsersPage(), //
        },
      ),
    );
  }
}

/// Decide where to go based on AuthState
class _RootPage extends StatelessWidget {
  const _RootPage();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else if (state.status == AuthStatus.unauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        body: Center(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.status == AuthStatus.loading ||
                  state.status == AuthStatus.initial) {
                return const CircularProgressIndicator();
              }
              if (state.status == AuthStatus.failure) {
                return Text(state.message ?? 'Error');
              }
              // Le listener gère la navigation
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

Future<void> _seedAdminUser() async {
  final box = Hive.box(AuthLocalDataSourceImpl.usersBoxName);
  const adminEmail = 'admin@qualitysphere.com';
  if (!box.containsKey(adminEmail)) {
    await box.put(adminEmail, {
      'id': 'admin',
      'name': 'Admin User',
      'email': adminEmail,
      'password': 'admin123', // juste pour test / démo
    });
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  // Open users box
  await Hive.openBox(AuthLocalDataSourceImpl.usersBoxName);

  await _seedAdminUser();
  await di.init();
  runApp(const QualitySphereApp());
}
