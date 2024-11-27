part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

final class GetProjectsEvent extends DashboardEvent {

}

final class CreateProjectEvent extends DashboardEvent {
  final String name;

  CreateProjectEvent({required this.name});
}

final class UpdateProjectEvent extends DashboardEvent {
  final ProjectRes project;

  UpdateProjectEvent({required this.project});
}

final class DeleteProjectEvent extends DashboardEvent {
  final ProjectRes project;

  DeleteProjectEvent({required this.project});
}
