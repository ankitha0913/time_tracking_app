import 'package:flutter/material.dart';
import 'package:time_tracking_app/core/theme/app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: AppColors.primary.withOpacity(0.5),
        child: const Center(
          child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              backgroundColor: AppColors.secondary
          ),
        ),
      ),
    );
  }
}
