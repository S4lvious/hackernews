import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:hackernews/models/story_model.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Story>> story;

  @override
  void initState() {
    super.initState();
    story = fetchStory();
  }

  Future<List<Story>> fetchStory() async {
    final response = await http.get(Uri.parse(
        'https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty'));
    final topStoriesIds = jsonDecode(response.body) as List<dynamic>;
    final topStoriesFutures = topStoriesIds.take(10).map((e) async {
      final storyResponse = await http.get(Uri.parse(
          'https://hacker-news.firebaseio.com/v0/item/$e.json?print=pretty'));
      final storyJson = jsonDecode(storyResponse.body);
      return Story.fromData(storyJson);
    }).toList();
    final topStories = Future.wait(topStoriesFutures);
    return topStories;
  }

  String fixIndex (int index) {
    final adjustedIndex = index + 1;
    return adjustedIndex.toString();
  }

  Widget body() => FutureBuilder<List<Story>>(
      future: story,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        } else {
          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (
              context,
              index,
            ) {
              return ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      fixIndex(index),
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                title: Text(snapshot.data![index].storyTitle),
                subtitle: Text(snapshot.data![index].storyAuthor),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () => {},
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("TOP STORIES HACKER NEWS"),
          centerTitle: true,
          backgroundColor: Colors.orange.shade400,
        ),
        body: Center(
          child: body(),
        ));
  }
}
