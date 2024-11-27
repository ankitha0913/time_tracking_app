import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:time_tracking_app/core/constants/api_endpoints.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/string_constants.dart';
import '../../core/utils/uuid_generator.dart';
import '../model/Task/Task_res.dart';
import 'package:http/http.dart' as http;

import '../model/task/create_task_req.dart';

class TaskApi {

  Future<TaskRes> createTask({required String projectId,required String name}) async {
    var response =
    await http.post(Uri.parse(ApiEndpoints.tasks),
        headers: {
          AppConstants.X_REQUEST_ID: UUIDGenerator.generate(),
          AppConstants.AUTHORIZATION:
          "${AppConstants.BEARER} ${AppConstants.ACCESS_TOKEN}"
        },
        body: CreateTaskReq(name: name,projectId: projectId).toJson());
    debugPrint(response.body);
    if (response.statusCode == 200) {
      return TaskRes.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(StringConstants.somethingWentWrong);
    }
  }

  Future<void> deleteTask({required String taskId}) async {
    var response =
    await http.delete(Uri.parse("${ApiEndpoints.tasks}/$taskId"),
        headers: {
          AppConstants.AUTHORIZATION:
          "${AppConstants.BEARER} ${AppConstants.ACCESS_TOKEN}"
        });
    debugPrint(response.body);
    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception(StringConstants.somethingWentWrong);
    }
  }

}