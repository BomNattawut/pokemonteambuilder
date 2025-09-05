import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class TeamController extends GetxController {
  var allPokemon = <Pokemon>[].obs;   
  var team = <Pokemon>[].obs;         
  var teamName = "My Team".obs;       
  var searchQuery = "".obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadData();
    if (allPokemon.isEmpty) {
      fetchPokemon(); 
    }
  }

 
  Future<void> fetchPokemon() async {
    final url = Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=20");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List results = data["results"];

      allPokemon.value = results.asMap().entries.map((entry) {
        final index = entry.key + 1; 
        final name = entry.value["name"];
        final imageUrl =
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$index.png";
        return Pokemon(name: name, imageUrl: imageUrl);
      }).toList();
    } else {
      Get.snackbar("Error", "Failed to load Pokémon");
    }
  }

  List<Pokemon> get filteredPokemon {
  if (searchQuery.isEmpty) {
    return allPokemon;
  }
  return allPokemon
      .where((p) => p.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
      .toList();
}


  void setSearchQuery(String query) {
  searchQuery.value = query;
}
  void addToTeam(Pokemon pokemon) {
    if (team.length < 3 && !team.contains(pokemon)) {
      team.add(pokemon);
      saveData();
    }
  }

  void removeFromTeam(Pokemon pokemon) {
    team.remove(pokemon);
    saveData();
  }

  void setTeamName(String name) {
    teamName.value = name;
    saveData();
  }

  void resetTeam() {
    team.clear();
    saveData();
  }

  void saveData() {
    storage.write("team", team.map((p) => {
      "name": p.name,
      "imageUrl": p.imageUrl,
    }).toList());
    storage.write("teamName", teamName.value);
  }

  void loadData() {
    var savedTeam = storage.read("team") ?? [];
    var savedName = storage.read("teamName") ?? "My Team";

    team.value = List<Pokemon>.from(
      savedTeam.map((data) => Pokemon(
        name: data["name"],
        imageUrl: data["imageUrl"],
      )),
    );
    teamName.value = savedName;
  }
}
