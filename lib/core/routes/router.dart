import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/home_page.dart';
import '../../features/staff_management_page.dart';
import '../../features/supplier/presentation/pages/add_supplier_page.dart';
import '../../features/supplier/presentation/pages/edit_supplier_page.dart';
import '../../features/supplier/presentation/pages/supplier_detail_page.dart';
import '../../features/supplier/presentation/pages/supplier_page.dart';
import '../../features/tracker/presentation/pages/cancel_page.dart';
import '../../features/tracker/presentation/pages/check_page.dart';
import '../../features/tracker/presentation/pages/pack_page.dart';
import '../../features/tracker/presentation/pages/pick_up_page.dart';
import '../../features/tracker/presentation/pages/receipt_status_page.dart';
import '../../features/tracker/presentation/pages/report_page.dart';
import '../../features/tracker/presentation/pages/return_page.dart';
import '../../features/tracker/presentation/pages/scan_page.dart';
import '../../features/tracker/presentation/pages/send_page.dart';
import '../../features/tracker/presentation/pages/shipment_detail_page.dart';
import '../../features/tracker/presentation/pages/tracker_page.dart';
import '../../features/tracker/presentation/pages/upload_page.dart';
import '../../features/tracker/presentation/widgets/open_camera.dart';
import '../../features/warehouse/presentation/pages/add_shipping_fee_page.dart';
import '../../features/warehouse/presentation/pages/warehouse_page.dart';
import '../../main.dart';
import '../common/constants.dart';
import '../common/scaffold_with_bottom_navigation_bar.dart';

FadeTransition transition(Animation<double> animation, Widget child) =>
    FadeTransition(
      opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
      child: child,
    );

Widget transitionsBuilder(BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) =>
    transition(animation, child);

final _rootNavigatorkey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _staffManagementNavigatorKey = GlobalKey<NavigatorState>();
final _profileNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorkey,
  initialLocation: initialLocation,
  routes: [
    GoRoute(
      path: loginRoute,
      pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignInPage(),
          transitionsBuilder: transitionsBuilder),
    ),
    GoRoute(
      path: cameraRoute,
      pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: TakePictureScreen(camera: cameras.first),
          transitionsBuilder: transitionsBuilder),
    ),
    GoRoute(
      path: displayPictureRoute,
      pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: DisplayPictureScreen(image: state.extra as XFile),
          transitionsBuilder: transitionsBuilder),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithBottomNavigationBar(child: navigationShell),
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: homeRoute,
              builder: (context, state) => const HomePage(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'tracker',
                  builder: (context, state) => const TrackerPage(),
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'scan',
                      builder: (context, state) => const ScanPage(),
                    ),
                    GoRoute(
                      path: 'pick-up',
                      builder: (context, state) => const PickUpPage(),
                    ),
                    GoRoute(
                      path: 'check',
                      builder: (context, state) => const CheckPage(),
                    ),
                    GoRoute(
                      path: 'pack',
                      builder: (context, state) => const PackPage(),
                    ),
                    GoRoute(
                      path: 'send',
                      builder: (context, state) => const SendPage(),
                    ),
                    GoRoute(
                      path: 'return',
                      builder: (context, state) => const ReturnPage(),
                    ),
                    GoRoute(
                      path: 'cancel',
                      builder: (context, state) => const CancelPage(),
                    ),
                    GoRoute(
                      path: 'report',
                      builder: (context, state) => const ReportPage(),
                    ),
                    GoRoute(
                      path: 'status',
                      builder: (context, state) => const ReceiptStatusPage(),
                    ),
                    GoRoute(
                      path: 'detail',
                      builder: (context, state) =>
                          ShipmentDetailPage(shipmentId: state.extra as String),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'supplier',
                  builder: (context, state) => const SupplierPage(),
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'add',
                      builder: (context, state) => const AddSupplierPage(),
                    ),
                    GoRoute(
                      path: 'detail',
                      builder: (context, state) => SupplierDetailPage(
                        supplierId: state.extra as String,
                      ),
                    ),
                    GoRoute(
                      path: 'edit',
                      builder: (context, state) => EditSupplierPage(
                        supplierId: state.extra as String,
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'warehouse',
                  builder: (context, state) => const WarehousePage(),
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'add-shipping-fee',
                      builder: (context, state) => const AddShippingFeePage(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _staffManagementNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: staffManagementRoute,
              builder: (context, state) => const StaffManagementPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: profileRoute,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
