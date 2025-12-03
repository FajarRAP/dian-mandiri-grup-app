import 'package:flutter/material.dart';

import '../../../../../common/constants/app_constants.dart';
import '../../widgets/stage_layout.dart';

class PickUpPage extends StatelessWidget {
  const PickUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StageLayout(
      appBarTitle: 'Scan Ambil Barang',
      stage: AppConstants.pickUpStage,
    );
  }
}
