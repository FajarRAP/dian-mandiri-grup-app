import 'package:flutter/material.dart';

import '../../../../../core/common/constants.dart';
import '../../widgets/stage_layout.dart';

class CancelPage extends StatelessWidget {
  const CancelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StageLayout(
      appBarTitle: 'Barang Cancel',
      stage: cancelStage,
    );
  }
}
