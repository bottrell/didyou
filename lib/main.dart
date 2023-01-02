import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Character> makeHTTPRequest(int id) async {
  String url = "https://rickandmortyapi.com/api/character/${id}";
  print(url);
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return Character.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load cat');
  }
}

class Character {
  final String name;
  final NetworkImage image;

  Character({required this.name, required this.image});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(name: json["name"], image: NetworkImage(json["url"]));
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<Future<Character>>? futureCharacters;

  @override
  void initState() {
    for (int i = 1; i < 100; i++) {
      futureCharacters?.add(makeHTTPRequest(i));
    } 
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello, World!",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Rick and Morty Rick and Morty"),
        ),
        body: Container(
            width: double.infinity,
            child: FutureBuilder<Character>(
              future: futureCharacters![20],
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.name);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            )),
      ),
    );
  }
}
