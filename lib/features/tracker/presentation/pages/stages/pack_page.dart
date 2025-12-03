import 'package:flutter/material.dart';

import '../../../../../common/constants/app_constants.dart';
import '../../widgets/stage_layout.dart';

class PackPage extends StatelessWidget {
  const PackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StageLayout(
      appBarTitle: 'Scan Packing',
      stage: AppConstants.packStage,
    );
  }
}
