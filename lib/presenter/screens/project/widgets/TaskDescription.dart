import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_app/data/model/Task/Task_res.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../common_widgets/NameFieldDialog.dart';
import '../bloc/project_bloc.dart';

class TaskDescription extends StatelessWidget {
  const TaskDescription({
    super.key,
    required this.task,
  });

  final TaskRes task;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.dehaze_sharp,
            color: AppColors.primary,
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.6,
            child: Text(
              task.description ?? "",
              style: const TextStyle(color: AppColors.primary, fontSize: 15),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => NameFieldDialog(
                  title: StringConstants.description,
                  name: task.description,
                  isRequired: false,
                  onCreate: (String description) {
                    task.description = description;
                    context
                        .read<ProjectBloc>()
                        .add(UpdateTaskEvent(task: task));
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}