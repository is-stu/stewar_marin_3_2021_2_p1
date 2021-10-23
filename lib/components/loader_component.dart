import 'package:flutter/material.dart';

class LoaderComponent extends StatelessWidget {
  final String text;

  LoaderComponent({this.text = ''});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 150,
        decoration: BoxDecoration(
            color: const Color(0xFFFF8000),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
