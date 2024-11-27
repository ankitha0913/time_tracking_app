import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:time_tracking_app/core/theme/app_colors.dart';

extension DialogExtns on BuildContext {
  void showToast({required String message, bool isError=false}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: isError?AppColors.red:AppColors.secondary,
        textColor:isError?AppColors.secondary: AppColors.primary,
        fontSize: 14.0
    );
  }
}