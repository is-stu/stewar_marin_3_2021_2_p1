import 'dart:convert';

import 'package:animestewar/components/loader_component.dart';
import 'package:animestewar/helpers/constants.dart';
import 'package:animestewar/models/anime_model.dart';
import 'package:animestewar/screens/detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showLoader = false;
  List<Anime> animes = [];
  @override
  void initState() {
    super.initState();
    _getAnimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Best Animes'),
        backgroundColor: const Color(0xFFFF8000),
      ),
      body: showLoader
          ? LoaderComponent(
              text: 'Espere por favor...',
            )
          : _getContent(),
    );
  }

  void _getAnimes() async {
    setState(() {
      showLoader = true;
    });
    var url = Uri.parse(Constants.apiURL);
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json'
      },
    );
    setState(() {
      showLoader = false;
    });
    var body = response.body;
    var decodedJson = jsonDecode(body);

    if (decodedJson != null) {
      for (var item in decodedJson['data']) {
        animes.add(Anime.fromJson(item));
      }
    }
  }

  Widget _getContent() {
    return animes.isEmpty ? _noContent() : _getListViews();
  }

  Widget _noContent() {
    return Center(
      child: Container(
          margin: const EdgeInsets.all(20),
          child: const Text('No hay animes disponibles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
    );
  }

  Widget _getListViews() {
    return ListView(
      children: animes.map((e) {
        return Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailScreen(
                            anime: e,
                          )));
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      e.animeImg,
                      width: 50,
                    ),
                  ),
                  Text(
                    e.animeName,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
