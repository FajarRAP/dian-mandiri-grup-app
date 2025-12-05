import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'common/utils/top_snackbar.dart';
import 'core/presentation/cubit/app_cubit.dart';
import 'core/presentation/cubit/user_cubit.dart';
import 'core/router/app_router.dart';
import 'core/router/route_names.dart';
import 'core/services/google_sign_in_service.dart';
import 'core/themes/app_theme.dart';
import 'core/utils/app_bloc_observer.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'firebase_options.dart';
import 'service_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting('id_ID', null);

  setup();

  await getIt<GoogleSignInService>().initialize();

  Bloc.observer = const AppBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<UserCubit>()),
        BlocProvider(create: (context) => getIt<AppCubit>()),
        BlocProvider(create: (context) => getIt<AuthCubit>()),
      ],
      child: MaterialApp.router(
        builder: (context, child) => BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              context.goNamed(Routes.login);
            }
          },
          child: Overlay(
            initialEntries: <OverlayEntry>[
              OverlayEntry(
                builder: (context) {
                  TopSnackbar.init(context);
                  return child!;
                },
              ),
            ],
          ),
        ),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'Ship Tracker',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: .light,
        routerConfig: AppRouter.router,
        supportedLocales: const [Locale('en', 'US'), Locale('id')],
      ),
    );
  }
}
