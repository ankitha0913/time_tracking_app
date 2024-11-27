import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boardview/board_item.dart';
import 'package:flutter_boardview/board_list.dart';
import 'package:flutter_boardview/boardview.dart';
import 'package:flutter_boardview/boardview_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:time_tracking_app/core/constants/string_constants.dart';
import 'package:time_tracking_app/core/constants/task_board.dart';
import 'package:time_tracking_app/core/theme/app_colors.dart';
import 'package:time_tracking_app/core/utils/date_time_util.dart';
import 'package:time_tracking_app/core/utils/toast_util.dart';
import 'package:time_tracking_app/data/model/Task/Task_res.dart';
import 'package:time_tracking_app/data/model/project/project_res.dart';
import 'package:time_tracking_app/data/model/task/completed_task_res.dart';
import 'package:time_tracking_app/presenter/screens/project/bloc/project_bloc.dart';

import '../../../../core/constants/app_route_constants.dart';
import '../../../common_widgets/AppLoader.dart';
import '../../../common_widgets/NameFieldDialog.dart';
import '../widgets/TaskCard.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key, required this.project});
  final ProjectRes project;

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  BoardViewController boardViewController = BoardViewController();

  @override
  void initState() {
    super.initState();
    context
        .read<ProjectBloc>()
        .add(GetTasksEvent(projectId: widget.project.id ?? ""));
  }

  void _createTask() {
    showDialog(
      context: context,
      builder: (context) => NameFieldDialog(
        title: StringConstants.taskPopUpTitle,
        onCreate: (String name) {
          context.read<ProjectBloc>().add(
              CreateTaskEvent(name: name, projectId: widget.project.id ?? ""));
        },
      ),
    );
  }

  void _onItemMoved({int? fromIndex, int? toIndex, required TaskRes task}) {
    if (fromIndex != toIndex && toIndex != null && fromIndex != null) {
      task.state = TaskBoard.values[toIndex].stringValue;
      context.read<ProjectBloc>().add(UpdateTaskEvent(task: task));
      if (task.state == TaskBoard.done.stringValue) {
        context.read<ProjectBloc>().add(TaskCompleteEvent(
            task: CompletedTaskRes(
                projectId: widget.project.id ?? "",
                name: task.name,
                taskId: task.id,
                dateCompleted: DateTimeUtil.formatDate(DateTime.now()))));
      }
      if (TaskBoard.values[fromIndex] == TaskBoard.done) {
        context.read<ProjectBloc>().add(UndoCompleteEvent(task: task));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: taskAppBar(),
      body: BlocConsumer<ProjectBloc, ProjectState>(listener: (context, state) {
        if (state is ProjectFailure) {
          return context.showToast(message: state.message, isError: true);
        }
      }, builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: BoardView(
                lists: List.generate(TaskBoard.values.length, (boardIndex) {
                  List<TaskRes> boardTasks = state.tasks!
                      .where((task) =>
                          task.state ==
                          TaskBoard.values[boardIndex].stringValue)
                      .toList();
                  return BoardList(
                    onStartDragList: (int? listIndex) {},
                    onTapList: (int? listIndex) async {},
                    onDropList: (int? listIndex, int? oldListIndex) {},
                    headerBackgroundColor: AppColors.cyan.withOpacity(0.5),
                    backgroundColor: AppColors.cyan.withOpacity(0.75),
                    header: [
                      boardHeader(TaskBoard.values[boardIndex].stringValue),
                    ],
                    items: List.generate(
                      boardTasks.length,
                      (taskIndex) => BoardItem(
                        onStartDragItem: (int? listIndex, int? itemIndex,
                            BoardItemState state) {},
                        onDropItem: (int? listIndex,
                                int? itemIndex,
                                int? oldListIndex,
                                int? oldItemIndex,
                                BoardItemState state) =>
                            _onItemMoved(
                                fromIndex: oldListIndex,
                                toIndex: listIndex,
                                task: boardTasks[taskIndex]),
                        onTapItem: (int? listIndex, int? itemIndex,
                            BoardItemState state) async {},
                        item: TaskCard(task: boardTasks[taskIndex]),
                      ),
                    ),
                  );
                }),
                boardViewController: boardViewController,
              ),
            ),
            if (state is ProjectLoading) const AppLoader()
          ],
        );
      }),
    );
  }

  AppBar taskAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      automaticallyImplyLeading: false,
      actions: [
        addTaskWidget(onCreate: _createTask),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: historyWidget(),
        )
      ],
      title: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(widget.project.name ?? "",
            style: const TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.w800,
                fontSize: 25)),
      ),
    );
  }

  Widget boardHeader(String title) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20),
        ));
  }

  Widget addTaskWidget({required VoidCallback onCreate}) {
    return GestureDetector(
      onTap: onCreate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: const Row(
          children: [
            Icon(Icons.add),
            SizedBox(
              width: 5,
            ),
            Text(StringConstants.addTask)
          ],
        ),
      ),
    );
  }

  Widget historyWidget() {
    return IconButton(
        onPressed: () {
          GoRouter.of(context)
              .pushNamed(AppRouteConstants.historyRouteName, pathParameters: {
            'projectId': widget.project.id ?? "",
          });
        },
        icon: const Icon(
          Icons.history,
          color: AppColors.secondary,
          size: 30,
        ));
  }
}
