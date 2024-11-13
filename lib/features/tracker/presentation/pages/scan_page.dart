import 'package:flutter/material.dart';

import '../../../../core/common/constants.dart';
import '../widgets/stage_layout.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StageLayout(
      appBarTitle: 'Scan Resi',
      stageId: scanStage,
      
    );
  }
}
