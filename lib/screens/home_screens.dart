import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:animestewar/components/loader_component.dart';
import 'package:animestewar/helpers/constants.dart';
import 'package:animestewar/models/anime_model.dart';
import 'package:animestewar/screens/detail_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showLoader = false;
  List<Anime> animes = [];
  List<Anime> filterAnime = [];
  bool isSearching = false;
  @override
  void initState() {
    super.initState();
    _getAnimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text('Animes', style: GoogleFonts.acme(fontSize: 23))
            : TextField(
                onChanged: (value) {
                  filterName(value);
                },
                style: GoogleFonts.acme(),
                decoration: const InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Encuentra tu anime",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        actions: [
          isSearching
              ? IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      filterAnime = animes;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                )
        ],
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
    var connecResult = await Connectivity().checkConnectivity();
    if (connecResult == ConnectivityResult.none) {
      setState(() {
        showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'ERROR!',
          message: 'Verifica tu conexion a internet!',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar')
          ]);
      return;
    }
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
      filterAnime = animes;
    }
  }

  Widget _getContent() {
    return animes.isEmpty ? _noContent() : _getListViews();
  }

  Widget _noContent() {
    return Center(
      child: Container(
          margin: const EdgeInsets.all(20),
          child: Text('No hay animes disponibles',
              style: GoogleFonts.acme(fontSize: 20))),
    );
  }

  Widget _getListViews() {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: filterAnime.map((e) {
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
                    style: GoogleFonts.acme(fontSize: 25),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFFF8000),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void filterName(value) {
    setState(() {
      filterAnime = animes
          .where((element) => element.animeName
              .toLowerCase()
              .contains(value.toString().toLowerCase()))
          .toList();
    });
  }
}
