import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_tracking_app/core/constants/string_constants.dart';
import 'package:time_tracking_app/core/theme/app_colors.dart';
import 'package:time_tracking_app/core/utils/toast_util.dart';

class NameFieldDialog extends StatefulWidget {
  const NameFieldDialog({
    super.key,
    required this.title,
    required this.onCreate,
    this.name,
    this.isRequired = true
  });
  final Function(String) onCreate;
  final String title;
  final String? name;
  final bool isRequired;

  @override
  State<NameFieldDialog> createState() => _NameFieldDialogState();
}

class _NameFieldDialogState extends State<NameFieldDialog> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    nameController.text= widget.name ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        widget.title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: nameField(),
      actions: [
        cancelButton(),
        saveButton(),
      ],
    );
  }

  Widget nameField(){
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.6,
      child: TextField(
        controller: nameController,
        decoration: InputDecoration(
          hintText: StringConstants.nameFieldHintText,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary,), // Set the color and width
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget saveButton(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
      onPressed: () {
        String name = nameController.text.trim();
        if(widget.isRequired && name.isEmpty){
          context.showToast(
              message: StringConstants.nameFieldValidationMessage,isError: true);
        }else{
          GoRouter.of(context).pop();
          widget.onCreate(name);
        }
      },
      child: const Text(
        StringConstants.save,
        style: TextStyle(color: AppColors.secondary),
      ),
    );
  }

  Widget cancelButton(){
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
}
