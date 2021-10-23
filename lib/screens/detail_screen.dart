import 'dart:convert';

import 'package:animestewar/components/loader_component.dart';
import 'package:animestewar/models/fact_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:animestewar/helpers/constants.dart';
import 'package:animestewar/models/anime_model.dart';

class DetailScreen extends StatefulWidget {
  final Anime anime;

  DetailScreen({required this.anime});
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool showLoader = false;
  int totalFacts = 0;
  List<Fact> facts = [];
  @override
  void initState() {
    super.initState();
    _getAnimeDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detalle ${widget.anime.animeName}'),
          backgroundColor: const Color(0xFFFF8000),
        ),
        body: showLoader
            ? LoaderComponent(
                text: 'Espere por favor...',
              )
            : Column(
                children: [
                  principalImage(),
                  animesName(),
                  factsTotal(),
                  const Divider(
                    color: Colors.black,
                    indent: 10,
                  ),
                  const Text('Todas las facts:'),
                  listFacts(),
                ],
              ));
  }

  void _getAnimeDetail() async {
    setState(() {
      showLoader = true;
    });
    var url = Uri.parse(Constants.apiURL + '/' + widget.anime.animeName);
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json'
      },
    );
    var body = response.body;
    var decodedJson = jsonDecode(body);

    if (decodedJson != null) {
      totalFacts = decodedJson['total_facts'];
      for (var item in decodedJson['data']) {
        facts.add(Fact.fromJson(item));
      }
    }
    setState(() {
      showLoader = false;
    });
  }

  Widget principalImage() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          widget.anime.animeImg,
          width: 250,
        ),
      ),
    );
  }

  Widget factsTotal() {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Text('Numero de Facts: $totalFacts',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget animesName() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Text('Titulo: ${widget.anime.animeName}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget listFacts() {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: facts.map((e) {
          return Card(
            color: const Color(0xFFFFB263),
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              child: Text(
                '${e.factId} ${e.fact} ',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
