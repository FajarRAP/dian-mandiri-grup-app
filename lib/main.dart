import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

import 'core/common/constants.dart';
import 'core/helpers/top_snackbar.dart';
import 'core/routes/router.dart';
import 'core/services/google_sign_in_service.dart';
import 'core/themes/theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/supplier/presentation/cubit/supplier_cubit.dart';
import 'features/tracker/presentation/cubit/shipment_cubit.dart';
import 'features/warehouse/presentation/cubit/warehouse_cubit.dart';
import 'firebase_options.dart';
import 'service_container.dart';

late String initialLocation;
late String externalPath;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final dir = await getExternalStorageDirectory();
  externalPath = '${dir?.path}';

  await initializeDateFormatting('id_ID', null);

  setup();

  await getIt<GoogleSignInService>().initialize();

  final storage = getIt.get<FlutterSecureStorage>();
  final refreshToken = await storage.read(key: refreshTokenKey);
  initialLocation = refreshToken != null ? homeRoute : loginRoute;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt.get<AuthCubit>()),
        BlocProvider(create: (context) => getIt.get<ShipmentCubit>()),
        BlocProvider(create: (context) => getIt.get<SupplierCubit>()),
        BlocProvider(create: (context) => getIt.get<WarehouseCubit>())
      ],
      child: MaterialApp.router(
        builder: (context, child) => Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(
              builder: (context) {
                TopSnackbar.init(context);
                return child!;
              },
            ),
          ],
        ),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'Ship Tracker',
        theme: theme,
        routerConfig: router,
        scaffoldMessengerKey: scaffoldMessengerKey,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('id'),
        ],
      ),
    );
  }
}
