import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/home_page.dart';
import '../../features/staff_management_page.dart';
import '../../features/supplier/presentation/pages/add_supplier_page.dart';
import '../../features/supplier/presentation/pages/edit_supplier_page.dart';
import '../../features/supplier/presentation/pages/supplier_detail_page.dart';
import '../../features/supplier/presentation/pages/supplier_page.dart';
import '../../features/tracker/presentation/cubit/shipment_detail/shipment_detail_cubit.dart';
import '../../features/tracker/presentation/cubit/shipment_list/shipment_list_cubit.dart';
import '../../features/tracker/presentation/cubit/shipment_report/shipment_report_cubit.dart';
import '../../features/tracker/presentation/pages/stages/cancel_page.dart';
import '../../features/tracker/presentation/pages/stages/check_page.dart';
import '../../features/tracker/presentation/pages/stages/pack_page.dart';
import '../../features/tracker/presentation/pages/stages/pick_up_page.dart';
import '../../features/tracker/presentation/pages/receipt_status_page.dart';
import '../../features/tracker/presentation/pages/report_page.dart';
import '../../features/tracker/presentation/pages/stages/return_page.dart';
import '../../features/tracker/presentation/pages/stages/scan_page.dart';
import '../../features/tracker/presentation/pages/stages/send_page.dart';
import '../../features/tracker/presentation/pages/shipment_detail_page.dart';
import '../../features/tracker/presentation/pages/tracker_page.dart';
import '../../features/tracker/presentation/pages/update_shipment_document_page.dart';
import '../../features/warehouse/presentation/pages/add_purchase_note_file_page.dart';
import '../../features/warehouse/presentation/pages/add_purchase_note_manual_page.dart';
import '../../features/warehouse/presentation/pages/add_shipping_fee_page.dart';
import '../../features/warehouse/presentation/pages/purchase_note_detail_page.dart';
import '../../features/warehouse/presentation/pages/warehouse_page.dart';
import '../../service_container.dart';
import '../common/constants.dart';
import '../presentation/pages/splash_page.dart';
import '../widgets/scaffold_with_bottom_navigation_bar.dart';
import 'route_names.dart';

FadeTransition transition(Animation<double> animation, Widget child) =>
    FadeTransition(
      opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
      child: child,
    );

Widget transitionsBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) => transition(animation, child);

final _rootNavigatorkey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _staffManagementNavigatorKey = GlobalKey<NavigatorState>();
final _profileNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  const AppRouter._();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorkey,
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: loginRoute,
        name: Routes.login,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignInPage(),
          transitionsBuilder: transitionsBuilder,
        ),
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
                name: Routes.home,
                builder: (context, state) => const HomePage(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'tracker',
                    name: Routes.tracker,
                    builder: (context, state) => const TrackerPage(),
                    routes: <RouteBase>[
                      _buildRouteWithCubit<ShipmentListCubit>(
                        path: 'scan',
                        name: Routes.trackerScan,
                        child: (state) => const ScanPage(),
                      ),
                      _buildRouteWithCubit<ShipmentListCubit>(
                        path: 'pick-up',
                        name: Routes.trackerPickUp,
                        child: (state) => const PickUpPage(),
                      ),
                      _buildRouteWithCubit<ShipmentListCubit>(
                        path: 'check',
                        name: Routes.trackerCheck,
                        child: (state) => const CheckPage(),
                      ),
                      _buildRouteWithCubit<ShipmentListCubit>(
                        path: 'pack',
                        name: Routes.trackerPack,
                        child: (state) => const PackPage(),
                      ),
                      _buildRouteWithCubit<ShipmentListCubit>(
                        path: 'send',
                        name: Routes.trackerSend,
                        child: (state) => const SendPage(),
                      ),
                      _buildRouteWithCubit<ShipmentListCubit>(
                        path: 'return',
                        name: Routes.trackerReturn,
                        child: (state) => const ReturnPage(),
                      ),
                      _buildRouteWithCubit<ShipmentListCubit>(
                        path: 'cancel',
                        name: Routes.trackerCancel,
                        child: (state) => const CancelPage(),
                      ),
                      _buildRouteWithCubit<ShipmentReportCubit>(
                        path: 'report',
                        name: Routes.trackerReport,
                        child: (state) => const ReportPage(),
                      ),
                      _buildRouteWithCubit<ShipmentDetailCubit>(
                        path: 'status',
                        name: Routes.trackerStatus,
                        child: (state) => const ReceiptStatusPage(),
                      ),
                      _buildRouteWithCubit<ShipmentDetailCubit>(
                        path: 'detail',
                        name: Routes.trackerDetail,
                        child: (state) => ShipmentDetailPage(
                          shipmentId: state.extra as String,
                        ),
                      ),
                      GoRoute(
                        path: displayPictureRoute,
                        name: Routes.trackerPickedDocument,
                        builder: (context, state) {
                          final extras = state.extra as Map<String, dynamic>;
                          final imagePath = extras['image_path'] as String;
                          final shipmentId = extras['shipment_id'] as String;
                          final stage = extras['stage'] as String;
                          final cubit = extras['cubit'] as ShipmentDetailCubit;

                          return BlocProvider.value(
                            value: cubit,
                            child: UpdateShipmentDocumentPage(
                              imagePath: imagePath,
                              shipmentId: shipmentId,
                              stage: stage,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'supplier',
                    name: Routes.supplier,
                    builder: (context, state) => const SupplierPage(),
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'detail',
                        name: Routes.supplierDetail,
                        builder: (context, state) => SupplierDetailPage(
                          supplierId: state.extra as String,
                        ),
                      ),
                      GoRoute(
                        path: 'add',
                        name: Routes.supplierAdd,
                        builder: (context, state) => const AddSupplierPage(),
                      ),
                      GoRoute(
                        path: 'edit',
                        name: Routes.supplierEdit,
                        builder: (context, state) =>
                            EditSupplierPage(supplierId: state.extra as String),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'warehouse',
                    name: Routes.warehouse,
                    builder: (context, state) => const WarehousePage(),
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'detail',
                        name: Routes.warehouseDetail,
                        builder: (context, state) => PurchaseNoteDetailPage(
                          purchaseNoteId: state.extra as String,
                        ),
                      ),
                      GoRoute(
                        path: 'add-purchase-note-manual',
                        name: Routes.warehouseAddPurchaseNoteManual,
                        builder: (context, state) =>
                            const AddPurchaseNoteManualPage(),
                      ),
                      GoRoute(
                        path: 'add-purchase-note-file',
                        name: Routes.warehouseAddPurchaseNoteFile,
                        builder: (context, state) =>
                            const AddPurchaseNoteFilePage(),
                      ),
                      GoRoute(
                        path: 'add-shipping-fee',
                        name: Routes.warehouseAddShippingFee,
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
                name: Routes.staffManagement,
                builder: (context, state) => const StaffManagementPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: profileRoute,
                name: Routes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static GoRoute
  _buildRouteWithCubit<T extends StateStreamableSource<Object?>>({
    required String path,
    required String name,
    required Widget Function(GoRouterState state) child,
  }) {
    return GoRoute(
      path: path,
      name: name,
      builder: (context, state) =>
          BlocProvider<T>(create: (context) => getIt<T>(), child: child(state)),
    );
  }
}
