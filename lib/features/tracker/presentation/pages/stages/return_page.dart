import 'package:flutter/material.dart';

import '../../../../../common/constants/app_constants.dart';
import '../../widgets/stage_layout.dart';

class ReturnPage extends StatelessWidget {
  const ReturnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StageLayout(
      appBarTitle: 'Scan Return',
      stage: AppConstants.returnStage,
    );
  }
}
