import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_tracking_app/data/model/project/project_res.dart';
import 'package:time_tracking_app/presenter/screens/dashboard/view/DashboardScreen.dart';
import 'package:time_tracking_app/presenter/screens/project/view/HistoryScreen.dart';
import 'package:time_tracking_app/presenter/screens/project/view/ProjectScreen.dart';

import '../constants/app_route_constants.dart';

class AppRouter {
  static GoRouter returnRouter() {
    GoRouter router = GoRouter(
        routes: [
          GoRoute(
            name: AppRouteConstants.dashboardRouteName,
            path: '/',
            pageBuilder: (context, state) {
              return  const MaterialPage(child: DashboardScreen());
            },
          ),
          GoRoute(
            name: AppRouteConstants.projectRouteName,
            path: '/project',
            pageBuilder: (context, state) {
              ProjectRes projectRes = state.extra as ProjectRes;
              return MaterialPage(
                  child: ProjectScreen(
                    project: projectRes
                  ));
            },
          ),
          GoRoute(
            name: AppRouteConstants.historyRouteName,
            path: '/history/:projectId',
            pageBuilder: (context, state) {
              return MaterialPage(
                  child: HistoryScreen(
                    projectId: state.pathParameters['projectId']??"",
                  ));
            },
          ),
        ]);
    return router;
  }
}