import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_tracking_app/core/constants/string_constants.dart';
import 'package:time_tracking_app/core/theme/app_colors.dart';

class DeleteItemDialog extends StatelessWidget {
  const DeleteItemDialog({
    super.key,
    required this.itemName,
    required this.onDelete,
  });
  final VoidCallback onDelete;
  final String itemName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        itemName,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        cancelButton(context),
        deleteButton(context),
      ],
    );
  }

  Widget cancelButton(BuildContext context){
    return TextButton(
      style: TextButton.styleFrom(
        overlayColor: AppColors.cyan,
      ),
      onPressed: () {
        GoRouter.of(context).pop();
      },
      child: const Text(
        StringConstants.cancel,
        style: TextStyle(color: AppColors.primary),
      ),
    );
  }

  Widget deleteButton(BuildContext context){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
      onPressed: (){
        GoRouter.of(context).pop();
        onDelete();
      },
      child: const Text(
        StringConstants.delete,
        style: TextStyle(color: AppColors.secondary),
      ),
    );
  }

}
