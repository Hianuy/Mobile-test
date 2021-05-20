import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rick_and_morty/api/character_api.dart';
import 'package:rick_and_morty/model/character.dart';
import 'package:rick_and_morty/page/details_page.dart';
import 'package:rick_and_morty/theme/colors.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty/widget/search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List characters = [];
  bool isLoading = false;
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();
    this.init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final characters = await CharacterApi.getCharacter(query);

    setState(() => this.characters = characters);
  }


  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("The Rick and Morty API"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: ListView.builder(
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final book = characters[index];

                  return buildListCharacters(book, context);
                },
              ),
            ),
          ],
        ),
      );



  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Name or Status or Specie',
        onChanged: searchBook,
      );


  Future searchBook(String query) async => debounce(() async {
        final characters = await CharacterApi.getCharacter(query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          this.characters = characters;
        });
      });

  Widget buildListCharacters(Character character, BuildContext buildContext) =>
      ListTile(
        leading: Image.network(
          character.image,
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
        title: Text(character.name),
        subtitle: Text(character.status),
        onTap: () {
          Navigator.push(
              buildContext,
              MaterialPageRoute(
                  builder: (buildContext) => DetailsPage(character)));
        },
      );
}
