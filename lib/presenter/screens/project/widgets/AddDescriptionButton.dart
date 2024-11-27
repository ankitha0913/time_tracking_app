import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_app/data/model/Task/Task_res.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../common_widgets/NameFieldDialog.dart';
import '../bloc/project_bloc.dart';

class AddDescriptionButton extends StatelessWidget {
  const AddDescriptionButton({
    super.key,
    required this.task,
  });

  final TaskRes task;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => NameFieldDialog(
              title: StringConstants.description,
              onCreate: (String description) {
                task.description = description;
                context
                    .read<ProjectBloc>()
                    .add(UpdateTaskEvent(task: task));
              },
            ),
          );
        },
        child: const Text(
          StringConstants.addDescription,
          style: TextStyle(fontSize: 20, color: AppColors.primary),
        ));
  }
}