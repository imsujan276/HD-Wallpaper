import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hdwallpaper/data/data.dart';
import 'package:hdwallpaper/models/photos_model.dart';
import 'package:hdwallpaper/widget/widget.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<PhotosModel> photos = new List();
  TextEditingController searchController = new TextEditingController();

  getSearchWallpaper() async {
    var searchQuery = searchController.text;
    if (searchQuery == null || searchQuery == '') {
      searchQuery = 'random';
    }
    photos = [];
    await http.get(
        "https://api.pexels.com/v1/search?query=$searchQuery&per_page=50&page=1",
        headers: {"Authorization": apiKEY}).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      jsonData["photos"].forEach((element) {
        PhotosModel photosModel = new PhotosModel();
        photosModel = PhotosModel.fromMap(element);
        photos.add(photosModel);
      });

      setState(() {});
    });
  }

  @override
  void initState() {
    getSearchWallpaper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Search",
              style: TextStyle(color: Colors.black87, fontFamily: 'Overpass'),
            ),
          ],
        ),
        elevation: 0.0,
        actions: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          hintText: "search wallpapers",
                          border: InputBorder.none),
                      onSubmitted: (text) {
                        print(text);
                        getSearchWallpaper();
                      },
                    )),
                    InkWell(
                        onTap: () {
                          getSearchWallpaper();
                        },
                        child: Container(child: Icon(Icons.search)))
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              wallPaper(photos, context),
            ],
          ),
        ),
      ),
    );
  }
}
