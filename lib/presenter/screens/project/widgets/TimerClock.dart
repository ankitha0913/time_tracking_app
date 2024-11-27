import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_app/core/constants/string_constants.dart';
import 'package:time_tracking_app/core/theme/app_colors.dart';
import 'package:time_tracking_app/core/utils/date_time_util.dart';
import 'package:time_tracking_app/data/model/Task/Task_res.dart';

import '../../../../core/constants/task_board.dart';
import '../bloc/project_bloc.dart';

class TimerClock extends StatefulWidget {
  final int initialTime;
  final TaskRes task;
  const TimerClock({super.key, required this.initialTime, required this.task});

  @override
  State<TimerClock> createState() => _TimerClockState();
}

class _TimerClockState extends State<TimerClock> {
  late int remainingTime;
  Timer? timer;
  late bool isInProgress;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.initialTime;
    isInProgress = widget.task.state == TaskBoard.inProgress.stringValue;
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime++;
      });
    });
  }

  void _timerAction() {
    if (timer?.isActive == true) {
      setState(() {
        timer?.cancel();
      });
      widget.task.timeSpent = remainingTime;
      context.read<ProjectBloc>().add(UpdateTaskEvent(task: widget.task));
    } else {
      setState(() {
        _startTimer();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
           Text(
             isInProgress?StringConstants.trackTime:StringConstants.timeSpent,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            textAlign: TextAlign.center,
            DateTimeUtil.formatTime(remainingTime),
            style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.visible),
          ),
        ),
        const SizedBox(width: 10),
        if (isInProgress)
          timerButton(),
      ],
    );
  }

  Widget timerButton(){
    return GestureDetector(
      onTap: _timerAction,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Icon(
          timer?.isActive == true
              ? Icons.pause_circle_sharp
              : Icons.play_arrow_sharp,
          color: AppColors.primary,
          size: 30,
        ),
      ),
    );
  }
  
}
