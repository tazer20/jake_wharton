// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jake_wharton/theme/colors.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.fetchUser();
  }

  fetchUser() async {
    var url = Uri.https('api.github.com', '/users/JakeWharton/repos',
        {'?page=1&per_page=15': '{http}'});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        users = items;
      });
    } else {
      setState(() {
        users = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Listing Users"),
        backgroundColor: Colors.pink,
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (users.contains(null) || users.length < 0 || isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return getCard(users[index]);
        });
  }

  Widget getCard(index) {
    var projectName = index['name'];
    var description = index['description'];
    var language = index['language'];
    var forks = index['forks_count'];
    var watchersCount = index['watchers_count'];
    return Card(
      child: Row(
        children: [
          Icon(
            Icons.book,
            size: 60.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                projectName.toString(),
                style: TextStyle(fontSize: 17),
              ),
              Container(
                height: 50,
                width: 300,
                child: Text(
                  description,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.code),
                    Text(language.toString()),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.bug_report),
                    Text(forks.toString()),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.face),
                    Text(watchersCount.toString()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
