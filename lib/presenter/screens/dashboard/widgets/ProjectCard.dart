import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_app/data/model/project/project_res.dart';
import 'package:time_tracking_app/presenter/screens/dashboard/bloc/dashboard_bloc.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/string_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../common_widgets/DeleteItemDialog.dart';
import '../../../common_widgets/NameFieldDialog.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});
  final ProjectRes project;

  void _editProject(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => NameFieldDialog(
        title: StringConstants.editName,
        name: project.name??"",
        onCreate: (String name) {
          project.name = name;
          context.read<DashboardBloc>().add(
              UpdateProjectEvent(project: project));
        },
      ),
    );
  }

  void _deleteProject(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => DeleteItemDialog(
        itemName: "${StringConstants.delete}: ${project.name}",
        onDelete: (){
          context.read<DashboardBloc>().add(
              DeleteProjectEvent(
                  project: project));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25,left: 25,right: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cyan,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.asset(
            AppIcons.projectIcon,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 10,),
          Text(
            project.name??"",
            style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w400,
                fontSize: 17),
          ),
          const Spacer(),
          IconButton(icon:const Icon(Icons.edit), onPressed: () {
            _editProject( context);
          },),
          IconButton(
            icon: const Icon(Icons.delete,),
            onPressed: () {
              _deleteProject(context);
            },
          )
        ],
      ),
    );
  }
}
