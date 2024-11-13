import 'package:flutter/material.dart';

import '../../../../core/common/constants.dart';
import '../widgets/stage_layout.dart';

class PickUpPage extends StatelessWidget {
  const PickUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StageLayout(
      appBarTitle: 'Scan Ambil Barang',
      stageId: pickUpStage,
      
    );
  }
}
