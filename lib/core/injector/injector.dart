import 'package:get_it/get_it.dart';
import 'package:time_tracking_app/data/api/project_api.dart';
import 'package:time_tracking_app/data/api/task_api.dart';
import 'package:time_tracking_app/domain/repo/project_repository.dart';

import '../../data/local/database_service.dart';
import '../../domain/repo/task_repository.dart';
import '../../presenter/screens/dashboard/bloc/dashboard_bloc.dart';
import '../../presenter/screens/project/bloc/project_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator.registerLazySingleton(
    () => DatabaseManager(),
  );

  serviceLocator<DatabaseManager>().initDb();

  serviceLocator.registerFactory<ProjectApi>(() => ProjectApi());

  serviceLocator.registerFactory<TaskApi>(() => TaskApi());

  serviceLocator.registerFactory<ProjectRepository>(
    () => ProjectRepository(
      serviceLocator(),serviceLocator()
    ),
  );

  serviceLocator.registerFactory<TaskRepository>(
    () => TaskRepository(
      serviceLocator(),serviceLocator()
    ),
  );

  serviceLocator.registerLazySingleton(
    () => DashboardBloc(
        projectRepository: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => ProjectBloc(
        taskRepository: serviceLocator(),),
  );
}
