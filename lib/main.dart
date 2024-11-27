import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_app/core/config/app_route_config.dart';
import 'package:time_tracking_app/presenter/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:time_tracking_app/presenter/screens/project/bloc/project_bloc.dart';

import 'core/injector/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const TimeTrackingApp());
}

class TimeTrackingApp extends StatelessWidget {
  const TimeTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => serviceLocator<DashboardBloc>(),
          ),
          BlocProvider(
            create: (_) => serviceLocator<ProjectBloc>(),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.returnRouter(),
        ),);
  }
}
