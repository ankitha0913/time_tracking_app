import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_app/data/model/Task/Task_res.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/constants/task_board.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../common_widgets/DeleteItemDialog.dart';
import '../../../common_widgets/NameFieldDialog.dart';
import '../bloc/project_bloc.dart';
import 'EditTaskDetails.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});
  final TaskRes task;

  void _editTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => NameFieldDialog(
        title: StringConstants.editName,
        name: task.name ?? "",
        onCreate: (String name) {
          task.name = name;
          context.read<ProjectBloc>().add(UpdateTaskEvent(task: task));
        },
      ),
    );
  }

  void _deleteTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DeleteItemDialog(
        itemName: "${StringConstants.delete}: ${task.name}",
        onDelete: () {
          context.read<ProjectBloc>().add(DeleteTaskEvent(task: task));
          if (task.state == TaskBoard.done.stringValue) {
            context.read<ProjectBloc>().add(UndoCompleteEvent(task: task));
          }
        },
      ),
    );
  }

  void _showTaskDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) {
        return TaskDetails(
          task: task,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTaskDetails(context),
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: AppColors.secondary.withOpacity(0.7)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                task.name ?? "",
              ),
            ),
            SizedBox(
              width: 25,
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  size: 20,
                ),
                onPressed: () => _editTask(context),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            SizedBox(
              width: 25,
              child: IconButton(
                icon: const Icon(
                  Icons.delete,
                  size: 20,
                ),
                onPressed: () => _deleteTask(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
