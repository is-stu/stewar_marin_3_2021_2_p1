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
  @override
  void initState() {
    _getAnimeDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detalle ${widget.anime.animeName}'),
          backgroundColor: const Color(0xFFFF8000),
        ),
        body: Column(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.anime.animeImg,
                  width: 250,
                ),
              ),
            ),
            Row(
              children: [Text('Titulo')],
            )
          ],
        ));
  }

  void _getAnimeDetail() async {
    var url = Uri.parse(Constants.apiURL + '/' + widget.anime.animeName);
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json'
      },
    );
    print(Constants.apiURL + widget.anime.animeName);
    print(response.body);
  }
}
