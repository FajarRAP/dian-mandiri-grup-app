import 'package:flutter/material.dart';

import '../../../../core/common/constants.dart';
import '../widgets/stage_layout.dart';

class CheckPage extends StatelessWidget {
  const CheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StageLayout(
      appBarTitle: 'Scan Checking',
      stageId: checkStage,
    );
  }
}
