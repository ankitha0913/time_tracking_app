import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:time_tracking_app/core/constants/string_constants.dart';
import 'package:time_tracking_app/core/theme/app_colors.dart';
import 'package:time_tracking_app/data/model/Task/Task_res.dart';
import 'package:time_tracking_app/presenter/common_widgets/NoDataWidget.dart';
import 'package:time_tracking_app/presenter/screens/project/widgets/HistoryTaskCard.dart';

import '../../../../data/model/task/completed_task_res.dart';
import '../../../common_widgets/AppLoader.dart';
import '../bloc/project_bloc.dart';
import '../widgets/TaskDetails.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.projectId});
  final String projectId;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context
        .read<ProjectBloc>()
        .add(GetHistoryEvent(projectId: widget.projectId));
  }

  void _onTaskSelected(
      {required List<CompletedTaskRes> completedTasks,
      required TaskRes selectedTask}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return TaskDetails(
          task: selectedTask,
          isCompletedView: true,
          whenCompletedViewClosed: () {
            context.read<ProjectBloc>().add(HistoryEvent(completedTasks));
            GoRouter.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: historyAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 25),
        child:
            BlocConsumer<ProjectBloc, ProjectState>(listener: (context, state) {
          if (state is HistorySuccess && state.selectedTask != null) {
            _onTaskSelected(
                completedTasks: state.historyTasks,
                selectedTask: state.selectedTask ?? TaskRes());
          }
        }, builder: (context, state) {
          if (state is ProjectLoading) {
            return const AppLoader();
          }
          if (state is HistorySuccess) {
            return state.historyTasks.isEmpty
                ? const NoDataWidget(text: StringConstants.noTasksToShow)
                : Column(
                    children: List.generate(
                    state.historyTasks.length,
                    (index) => HistoryTaskCard(
                      task: state.historyTasks[index],
                      onTap: () {
                        context.read<ProjectBloc>().add(GetTaskInfoEvent(
                            state.historyTasks,
                            projectId: widget.projectId,
                            taskId: state.historyTasks[index].taskId ?? ""));
                      },
                    ),
                  ));
          }
          return const NoDataWidget(text: StringConstants.couldNotLoadData);
        }),
      ),
    );
  }

  AppBar historyAppBar() {
    return AppBar(
      title: const Text(
        StringConstants.completedTasks,
        style: TextStyle(color: AppColors.secondary),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primary,
    );
  }
}
