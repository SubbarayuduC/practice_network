import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main(){
  runApp(MyApp());
}


Future<Comments>fetchComments() async {
  final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/comments/6"));

  if(response.statusCode == 200){
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Comments.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Comments');
  }
}


class Comments {
  // final int id;
  final String name;
  final String email;

  const Comments({
    // required this.id,
    required this.name,
    required this.email,
});
  factory Comments.fromJson(Map<String, dynamic>json) {
    return Comments(
      // id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Comments> futureComments;

  @override
  void initState(){
    super.initState();
    futureComments = fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetching Data from Internet',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data'),
        ),
        body: Center(
          child: FutureBuilder<Comments>(
          future: futureComments,
            builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data!.name),
                    Text(snapshot.data!.email),
                  ],
                );

              }else if(snapshot.hasError){
                return Text('${snapshot.error}');
              }
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
            },

          ),
        ),
      ),
    );

  }
}
