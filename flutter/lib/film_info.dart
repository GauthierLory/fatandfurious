import 'dart:convert';

import 'package:fatandfurious/film.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FilmInfo extends StatefulWidget {
  final String title;
  const FilmInfo({Key? key, required this.title}) : super(key: key);

  @override
  State<FilmInfo> createState() => _FilmInfoState();
}

class _FilmInfoState extends State<FilmInfo> {
  late Future<List<Film>> futureFilms;
  List<Film> films = [];

  Future<List<Film>> fetchFilm() async {
    final response = await http.get(
        Uri.parse('https://api.tvmaze.com/search/shows?q=${widget.title}'));

    // print(jsonDecode(response.body)[0]['show']['image']['medium']);

    if (response.statusCode == 200) {
      Film film;
      for (var filmInfo in jsonDecode(response.body)) {
        film = Film(
          title: filmInfo['show']['name'],
          summary: filmInfo['show']['summary'],
        );
        films.add(film);
      }
      return films;
    } else {
      throw Exception('Impossible de charger ce film');
    }
  }

  @override
  void initState() {
    super.initState();
    if (films.isEmpty) {
      futureFilms = fetchFilm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Film>>(
              future: futureFilms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      for (var info in snapshot.data!)
                        Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.video_collection),
                                title: Text(info.title),
                                subtitle: Text(info.summary
                                    .replaceAll("<p>", "")
                                    .replaceAll("</p>", "")
                                    .replaceAll("<b>", "")
                                    .replaceAll("</b>", "")
                                    .replaceAll("<i>", "")
                                    .replaceAll("</i>", "")),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                }

                // By default, show a loading spinner.
                return const Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
    );
  }
}
