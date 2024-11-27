import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_app/core/theme/app_colors.dart';
import 'package:time_tracking_app/core/utils/toast_util.dart';
import 'package:time_tracking_app/core/utils/uuid_generator.dart';
import 'package:time_tracking_app/data/model/Task/Task_res.dart';
import 'package:time_tracking_app/data/model/task/comment_res.dart';
import 'package:time_tracking_app/presenter/screens/project/bloc/project_bloc.dart';
import 'package:time_tracking_app/presenter/screens/project/widgets/TimerClock.dart';

import '../../../../core/constants/task_board.dart';
import 'AddComment.dart';
import 'AddDescriptionButton.dart';
import 'CommentSection.dart';
import 'TaskDescription.dart';

class TaskDetails extends StatefulWidget {
  const TaskDetails(
      {super.key,
      required this.task,
      this.isCompletedView = false,
      this.whenCompletedViewClosed});
  final TaskRes task;
  final bool isCompletedView;
  final VoidCallback? whenCompletedViewClosed;

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  final TextEditingController _commentController = TextEditingController();
  late bool isTodo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isTodo = widget.task.state == TaskBoard.todo.stringValue;
    context
        .read<ProjectBloc>()
        .add(GetCommentsEvent(taskId: widget.task.id ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cyan,
      width: double.infinity,
      height: MediaQuery.of(context).size.height *
          (widget.isCompletedView ? 0.9 : (isTodo ? 0.6 : 0.5)),
      padding: const EdgeInsets.all(15),
      child:
          BlocConsumer<ProjectBloc, ProjectState>(listener: (context, state) {
        if (state is ProjectFailure) {
          return context.showToast(message: state.message, isError: true);
        }
      }, builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isCompletedView)
              completedTaskHeader(),
            if (!isTodo)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TimerClock(
                  initialTime: widget.task.timeSpent ?? 0,
                  task: widget.task,
                ),
              ),
            widget.task.description == null || widget.task.description!.isEmpty
                ? AddDescriptionButton(task: widget.task)
                : TaskDescription(task: widget.task),
            (widget.task.comments != null && widget.task.comments!.isNotEmpty)
                ? Expanded(
                    child: CommentSection(comments: widget.task.comments ?? []),
                  )
                : const Spacer(),
            AddComment(
              controller: _commentController,
              onSend: () {
                CommentRes comment = CommentRes(
                    id: UUIDGenerator.generate(),
                    taskId: widget.task.id,
                    content: _commentController.text.trim());
                widget.task.comments?.add(comment);
                context
                    .read<ProjectBloc>()
                    .add(AddCommentEvent(comment: comment));
                _commentController.clear();
              },
            ),
          ],
        );
      }),
    );
  }

  Widget completedTaskHeader(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              textAlign: TextAlign.start,
              widget.task.name ?? "",
              style: const TextStyle(
                  fontSize: 30,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.visible),
            ),
          ),
        ),
        GestureDetector(
          onTap: widget.whenCompletedViewClosed,
          child: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const Icon(
              Icons.close_outlined,
              color: AppColors.secondary,
            ),
          ),
        )
      ],
    );
  }

}
