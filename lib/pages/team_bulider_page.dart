import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teambuilderapp/pages/previewteam.dart';
import '../controllers/team_controller.dart';
import '../models/pokemon.dart';

class TeamBuilderPage extends StatelessWidget {
  final TeamController controller = Get.put(TeamController());

  TeamBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.teamName.value)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.resetTeam,
          ),
        ],
      ),
      body: Column(
        children: [
         
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          hintText: "Search Pokémon...",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => controller.setSearchQuery(value),
      ),
    ),

    Obx(() => Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: controller.team.map((p) => _buildTeamMember(p)).toList(),
      ),
    )),

    const Divider(),

    Expanded(
      child: Obx(() => ListView.builder(
        itemCount: controller.filteredPokemon.length,
        itemBuilder: (context, index) {
          final p = controller.filteredPokemon[index];
          return _buildPokemonTile(p);
        },
      )),
    ),
        ],
      ),
      
      // ปุ่มแก้ไขชื่อทีม
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // ปุ่มแก้ไขชื่อทีม
          FloatingActionButton(
            heroTag: "editBtn",
            child: const Icon(Icons.edit),
            onPressed: () {
              Get.defaultDialog(
                title: "Edit Team Name",
                content: TextField(
                  decoration: const InputDecoration(
                    hintText: "Enter new team name",
                  ),
                  onSubmitted: (value) {
                    controller.setTeamName(value);
                    Get.back();
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 12),

          // ปุ่มไปหน้า Preview Team
          FloatingActionButton(
            heroTag: "previewBtn",
            backgroundColor: Colors.green,
            child: const Icon(Icons.visibility),
            onPressed: () {
              Get.to(() => PreviewTeamPage()); // 👈 ใช้ GetX routing
            },
          ),
        ],
      ),
       
    );

  }

  Widget _buildTeamMember(Pokemon p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Image.network(p.imageUrl, width: 60, height: 60),
          Text(p.name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPokemonTile(Pokemon p) {
  return Obx(() {
    final isSelected = controller.team.contains(p);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green[100] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: ListTile(
        leading: Image.network(p.imageUrl, width: 40, height: 40),
        title: Text(p.name),
        trailing: Icon(
          isSelected ? Icons.check_circle : Icons.add_circle_outline,
          color: isSelected ? Colors.green : Colors.grey,
        ),
        onTap: () {
          if (isSelected) {
            controller.removeFromTeam(p);
          } else {
            controller.addToTeam(p);
          }
        },
      ),
    );
  });
}

}
