part of 'dashboard_bloc.dart';

sealed class DashboardState {
   List<ProjectRes>? projects;
   DashboardState({this.projects});
}

final class DashboardInitial extends DashboardState {
   DashboardInitial({super.projects});
}

final class DashboardLoading extends DashboardState {
  DashboardLoading({super.projects});
}

final class DashboardSuccess extends DashboardState {
  DashboardSuccess({super.projects});
}

final class DashboardFailure extends DashboardState {
  final String message;
  DashboardFailure({
    required this.message,
    super.projects,
  });
}
