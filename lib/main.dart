import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:qualitysphere/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:qualitysphere/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:qualitysphere/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:qualitysphere/features/auth/domain/usecases/get_current_user.dart';
import 'package:qualitysphere/features/auth/domain/usecases/login.dart';
import 'package:qualitysphere/features/auth/domain/usecases/logout.dart';
import 'package:qualitysphere/features/auth/domain/usecases/register.dart';
import 'package:qualitysphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:qualitysphere/features/auth/presentation/pages/login_page.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ==== init très simple (plus tard نبدلوها ب GetIt) ====
  final dio = Dio();
  const baseUrl = 'https://api.qualitysphere.dev'; // TODO: change it
  final remoteDataSource = AuthRemoteDataSourceImpl(
    client: dio,
    baseUrl: baseUrl,
  );

  final prefs = await SharedPreferences.getInstance();
  final localDataSource = AuthLocalDataSourceImpl(prefs: prefs);

  final authRepository = AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  final loginUseCase = Login(authRepository);
  final registerUseCase = Register(authRepository);
  final getCurrentUserUseCase = GetCurrentUser(authRepository);
  final logoutUseCase = Logout(authRepository);
  // ====================================================

  runApp(
    BlocProvider(
      create: (_) => AuthBloc(
        loginUseCase: loginUseCase,
        registerUseCase: registerUseCase,
        getCurrentUserUseCase: getCurrentUserUseCase,
        logoutUseCase: logoutUseCase,
      )..add(const AuthCheckRequested()),
      child: const QualitySphereApp(),
    ),
  );
}

class QualitySphereApp extends StatelessWidget {
  const QualitySphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QualitySphere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0F6FFF),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      routes: {
        LoginPage.routeName: (_) => const LoginPage(),
        // '/home': (_) => const HomePage(), // TODO: dashboard
      },
      home: const LoginPage(), // مؤقتًا حتى نعمل splash/auth wrapper
    );
  }
}
