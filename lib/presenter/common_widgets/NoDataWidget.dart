import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.grey,
        ),
      ),
    );
  }
}
