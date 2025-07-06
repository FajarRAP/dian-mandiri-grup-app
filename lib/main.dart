import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ship_tracker/features/warehouse/presentation/cubit/warehouse_cubit.dart';

import 'core/common/constants.dart';
import 'core/routes/router.dart';
import 'core/themes/theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/supplier/presentation/cubit/supplier_cubit.dart';
import 'features/tracker/presentation/cubit/shipment_cubit.dart';
import 'firebase_options.dart';
import 'service_container.dart';

late List<CameraDescription> cameras;
late String initialLocation;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  cameras = await availableCameras();
  await initializeDateFormatting('id_ID', null);

  setup();

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
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'Ship Tracker',
        theme: theme,
        routerConfig: router,
        scaffoldMessengerKey: scaffoldMessengerKey,
        supportedLocales: const [
          Locale('en'),
          Locale('id'),
        ],
      ),
    );
  }
}
