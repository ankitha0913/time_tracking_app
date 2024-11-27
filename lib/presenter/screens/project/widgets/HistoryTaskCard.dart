import 'package:flutter/material.dart';
import 'package:time_tracking_app/data/model/task/completed_task_res.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/theme/app_colors.dart';

class HistoryTaskCard extends StatelessWidget {
  const HistoryTaskCard({super.key, required this.task, required this.onTap});
  final CompletedTaskRes task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 25, left: 25, right: 25),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cyan,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.name ?? "",
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 20)),
              Text("${StringConstants.completedOn} ${task.dateCompleted}"),
            ],
          ),
        ));
  }
}
