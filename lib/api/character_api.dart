import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rick_and_morty/model/character.dart';

class CharacterApi{
  static Future<List<Character>> getCharacter(String query) async {
    final url = Uri.parse(
      // 'https://gist.githubusercontent.com/JohannesMilke/d53fbbe9a1b7e7ca2645db13b995dc6f/raw/eace0e20f86cdde3352b2d92f699b6e9dedd8c70/books.json');
        'https://rickandmortyapi.com/api/character');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List characters = json.decode(response.body)['results'];

      return characters.map((json) => Character.fromJson(json)).where((character) {
        final name = character.name.toLowerCase();
        final status = character.status.toLowerCase();
        final species = character.species.toLowerCase();

        final searchLower = query.toLowerCase();

        return name.contains(searchLower) ||
            status.contains(searchLower) || species.contains(searchLower) ;
      }).toList();
    } else {
      throw Exception();
    }
  }

}