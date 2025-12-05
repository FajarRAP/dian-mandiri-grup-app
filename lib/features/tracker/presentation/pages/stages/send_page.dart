import 'package:flutter/material.dart';

import '../../../../../common/constants/app_constants.dart';
import '../../widgets/stage_layout.dart';

class SendPage extends StatelessWidget {
  const SendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StageLayout(
      appBarTitle: 'Scan Kirim',
      stage: AppConstants.sendStage,
    );
  }
}
