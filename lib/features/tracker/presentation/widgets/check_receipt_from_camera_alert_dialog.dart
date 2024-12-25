// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// import '../../../../core/common/snackbar.dart';
// import '../cubit/shipment_cubit.dart';

// class CheckReceiptFromCameraAlertDialog extends StatelessWidget {
//   const CheckReceiptFromCameraAlertDialog({
//     super.key,
//     required this.receiptNumber,
//   });

//   final String receiptNumber;

//   @override
//   Widget build(BuildContext context) {
//     final shipmentCubit = context.read<ShipmentCubit>();
//     final textTheme = Theme.of(context).textTheme;

//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       title: Text(
//         'Berhasil Scan!',
//         style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Nomor Resi:', style: textTheme.bodyMedium),
//           const SizedBox(height: 4),
//           Text(
//             receiptNumber,
//             style: textTheme.bodyLarge?.copyWith(
//               color: Colors.blueAccent,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(onPressed: context.pop, child: const Text('Batal')),
//         TextButton(
//           onPressed: () async => shipmentCubit.fetchShipmentByReceiptNumber(
//               receipNumber: receiptNumber),
//           child: BlocConsumer<ShipmentCubit, ShipmentState>(
//             listener: (context, state) {
//               if (state is FetchShipmentDetailLoaded) {
//                 context.pop();
//               }

//               if (state is FetchShipmentDetailError) {
//                 flushbar(state.message);
//               }
//             },
//             builder: (context, state) {
//               if (state is FetchShipmentDetailLoading) {
//                 return const CircularProgressIndicator();
//               }

//               return const Text(
//                 'Cari',
//                 style: TextStyle(fontWeight: FontWeight.w700),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
