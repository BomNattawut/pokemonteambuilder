import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teambuilderapp/controllers/team_controller.dart';

class PreviewTeamPage extends StatelessWidget {
  final TeamController controller = Get.find();

  PreviewTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Obx(() => Text(controller.teamName.value))),
      body: Obx(() => ListView(
            children: controller.team.map((p) {
              return ListTile(
                leading: Image.network(p.imageUrl),
                title: Text(p.name),
              );
            }).toList(),
          )),
    );
  }
}
