import 'package:flutter/material.dart';

import '../../../../../common/constants/app_constants.dart';
import '../../widgets/stage_layout.dart';

class CancelPage extends StatelessWidget {
  const CancelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StageLayout(
      appBarTitle: 'Barang Cancel',
      stage: AppConstants.cancelStage,
    );
  }
}
