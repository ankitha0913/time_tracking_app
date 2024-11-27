import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:time_tracking_app/core/theme/app_colors.dart';
import 'package:time_tracking_app/core/utils/toast_util.dart';
import 'package:time_tracking_app/data/model/project/project_res.dart';
import 'package:time_tracking_app/presenter/common_widgets/AppLoader.dart';
import 'package:time_tracking_app/presenter/common_widgets/NameFieldDialog.dart';
import 'package:time_tracking_app/presenter/common_widgets/NoDataWidget.dart';
import 'package:time_tracking_app/presenter/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:time_tracking_app/presenter/screens/dashboard/widgets/ProjectCard.dart';

import '../../../../core/constants/app_route_constants.dart';
import '../../../../core/constants/string_constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(GetProjectsEvent());
  }

  void _createProject(){
    showDialog(
      context: context,
      builder: (context) => NameFieldDialog(
        title: StringConstants.projectPopUpTitle,
        onCreate: (String name) {
          context
              .read<DashboardBloc>()
              .add(CreateProjectEvent(name: name));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Column(
            children: [
              dashboardHeaderWidget(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: BlocConsumer<DashboardBloc, DashboardState>(
                      listener: (context, state) {
                    if (state is DashboardFailure) {
                      return context.showToast(
                          message: state.message, isError: true);
                    }
                  }, builder: (context, state) {
                    return Stack(
                      children: [
                        state.projects!.isEmpty
                            ? const NoDataWidget(text: StringConstants.emptyProjectsMessage)
                            : Padding(
                                padding: const EdgeInsets.only(top: 25),
                                child:projectsWidget(state.projects) ,
                              ),
                        if (state is DashboardLoading) const AppLoader()
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 20),
        child: FloatingActionButton(
          onPressed:_createProject,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.secondary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget dashboardHeaderWidget(){
    return const Column(
      children: [
        Text(
          StringConstants.welcomeTitle,
          style: TextStyle(
              color: AppColors.cyan,
              fontWeight: FontWeight.w500,
              fontSize: 30),
        ),
        Text(
          StringConstants.welcomeMessage,
          style: TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.w400,
              fontSize: 17),
        ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }

  Widget projectsWidget(List<ProjectRes>? projects){
    return Column(
      children: List.generate(
          projects!.length,
              (index) => GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed(
                  AppRouteConstants
                      .projectRouteName,
                  extra:
                  projects[index]);
            },
            child: ProjectCard(
                project:
                projects[index]),
          )),
    );
  }

}
