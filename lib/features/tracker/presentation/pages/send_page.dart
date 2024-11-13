import 'package:flutter/material.dart';

import '../../../../core/common/constants.dart';
import '../widgets/stage_layout.dart';

class SendPage extends StatelessWidget {
  const SendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StageLayout(
      appBarTitle: 'Scan Kirim',
      stageId: sendStage,
    );
  }
}
