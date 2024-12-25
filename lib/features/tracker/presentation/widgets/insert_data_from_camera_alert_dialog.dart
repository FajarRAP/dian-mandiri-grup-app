// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// import '../../../../core/common/constants.dart';
// import '../../../../core/common/snackbar.dart';
// import '../../../../core/helpers/helpers.dart';
// import '../cubit/shipment_cubit.dart';

// class InsertDataFromCameraAlertDialog extends StatelessWidget {
//   const InsertDataFromCameraAlertDialog({
//     super.key,
//     required this.audioPlayer,
//     required this.receiptNumber,
//     required this.stage,
//   });

//   final AudioPlayer audioPlayer;
//   final String receiptNumber;
//   final String stage;

//   @override
//   Widget build(BuildContext context) {
//     final shipmentCubit = context.read<ShipmentCubit>();
//     final textTheme = Theme.of(context).textTheme;

//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
//           const SizedBox(height: 16),
//           Text('Nama Pemindai:', style: textTheme.bodyMedium),
//           Text(
//             'BOKEP NAMA',
//             style: textTheme.bodyLarge?.copyWith(
//               color: Colors.green,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(onPressed: context.pop, child: const Text('Batal')),
//         TextButton(
//           onPressed: () async => await shipmentCubit.insertShipment(
//               receiptNumber: receiptNumber, stage: stage),
//           child: BlocConsumer<ShipmentCubit, ShipmentState>(
//             buildWhen: (previous, current) => current is InsertShipment,
//             listener: (context, state) async {
//               if (state is InsertShipmentLoaded) {
//                 context.pop();
//                 flushbar(state.message);
//                 await audioPlayer.play(AssetSource(successSound));
//                 await shipmentCubit.fetchShipments(
//                     date: dateFormat.format(DateTime.now()), stage: stage);
//               }
//               if (state is InsertShipmentError) {
//                 flushbar(state.failure.message);

//                 // Need requested
//                 // switch (state.statusCode) {
//                 //   case 400:
//                 //     await audioPlayer.play(AssetSource(skipSound));
//                 //     break;
//                 //   case 401:
//                 //   case 23505:
//                 //     await audioPlayer.play(AssetSource(repeatSound));
//                 //     break;
//                 // }
//               }
//             },
//             builder: (context, state) {
//               if (state is InsertShipmentLoading) {
//                 return const CircularProgressIndicator();
//               }

//               return const Text(
//                 'Simpan',
//                 style: TextStyle(fontWeight: FontWeight.w700),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
