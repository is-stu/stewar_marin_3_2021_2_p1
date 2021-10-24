import 'package:animestewar/screens/home_screens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenidos', style: GoogleFonts.acme(fontSize: 23)),
        backgroundColor: const Color(0xFFFF8000),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: const Image(
                  image: AssetImage('assets/anime.jpg'),
                  width: 500,
                ),
              ),
              Text(
                'Bienvenidos a los mejores animes, continua para verlos',
                style: GoogleFonts.acme(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        },
        backgroundColor: const Color(0xFFFF8000),
        label: const Text('Continuar'),
        icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
      ),
    );
  }
}
