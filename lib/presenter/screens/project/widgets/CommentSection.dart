import 'package:flutter/material.dart';
import 'package:time_tracking_app/data/model/task/comment_res.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/theme/app_colors.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({
    super.key,
    required this.comments,
  });

  final List<CommentRes> comments;

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
      child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                StringConstants.comments,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w500),
              ),
              ...List.generate(
                comments.length,
                    (index) => Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                      comments[index].content ?? ""),
                ),
              ),
            ],
          )),
    );
  }
}