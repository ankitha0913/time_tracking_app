import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:time_tracking_app/core/constants/api_endpoints.dart';
import 'package:time_tracking_app/core/constants/string_constants.dart';
import 'package:time_tracking_app/data/model/project/create_project_req.dart';
import 'package:time_tracking_app/data/model/project/project_res.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/uuid_generator.dart';

class ProjectApi {
  Future<ProjectRes> createProject({required String name}) async {
    var response = await http.post(Uri.parse(ApiEndpoints.projects),
        headers: {
          AppConstants.X_REQUEST_ID: UUIDGenerator.generate(),
          AppConstants.AUTHORIZATION:
              "${AppConstants.BEARER} ${AppConstants.ACCESS_TOKEN}"
        },
        body: CreateProjectReq(name: name).toJson());
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return ProjectRes.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(StringConstants.somethingWentWrong);
    }
  }

  Future<List<ProjectRes>> getAllProjects() async {
    var response = await http.get(
      Uri.parse(ApiEndpoints.projects),
      headers: {
        AppConstants.AUTHORIZATION:
            "${AppConstants.BEARER} ${AppConstants.ACCESS_TOKEN}"
      },
    );
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final List<ProjectRes> projectList = (jsonDecode(response.body)
              as List<dynamic>)
          .where((item) => item['is_inbox_project'] != true) // excluding inbox
          .map((item) => ProjectRes.fromJson(item as Map<String, dynamic>))
          .toList();
      return projectList;
    } else {
      throw Exception(StringConstants.somethingWentWrong);
    }
  }

  Future<ProjectRes> updateProject(
      {required String projectId, required String name}) async {
    var response =
        await http.post(Uri.parse("${ApiEndpoints.projects}/$projectId"),
            headers: {
              AppConstants.X_REQUEST_ID: UUIDGenerator.generate(),
              AppConstants.AUTHORIZATION:
                  "${AppConstants.BEARER} ${AppConstants.ACCESS_TOKEN}"
            },
            body: CreateProjectReq(name: name).toJson());
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return ProjectRes.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(StringConstants.somethingWentWrong);
    }
  }

  Future<void> deleteProject({required String projectId}) async {
    var response = await http.delete(
      Uri.parse("${ApiEndpoints.projects}/$projectId"),
      headers: {
        AppConstants.AUTHORIZATION:
            "${AppConstants.BEARER} ${AppConstants.ACCESS_TOKEN}"
      },
    );
    debugPrint(response.body);
    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception(StringConstants.somethingWentWrong);
    }
  }
}
