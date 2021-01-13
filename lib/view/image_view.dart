import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'dart:js' as js;

class ImageView extends StatefulWidget {
  final String imgPath;

  ImageView({@required this.imgPath});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var filePath;

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imgPath,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: kIsWeb
                  ? Image.network(widget.imgPath, fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl: widget.imgPath,
                      placeholder: (context, url) => Container(
                        color: Color(0xfff5f8fd),
                      ),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 30, 0, 0),
            child: Container(
              width: 35.0,
              height: 35.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(500.0),
                color: Color(0xff1C1B1B).withOpacity(0.5),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white60,
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          if (kIsWeb) {
                            _launchURL(widget.imgPath);
                          } else {
                            _setWallPaper();
                          }
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xff1C1B1B).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width / 2.5,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white24, width: 1),
                                    borderRadius: BorderRadius.circular(40),
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0x36FFFFFF),
                                          Color(0x0FFFFFFF)
                                        ],
                                        begin: FractionalOffset.topLeft,
                                        end: FractionalOffset.bottomRight)),
                                child: Text(
                                  "Set As Wallpaper",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                )),
                          ],
                        )),
                    InkWell(
                        onTap: () {
                          if (kIsWeb) {
                            _launchURL(widget.imgPath);
                          } else {
                            _setLockScreenWallPaper();
                          }
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xff1C1B1B).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width / 2.5,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white24, width: 1),
                                    borderRadius: BorderRadius.circular(40),
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0x36FFFFFF),
                                          Color(0x0FFFFFFF)
                                        ],
                                        begin: FractionalOffset.topLeft,
                                        end: FractionalOffset.bottomRight)),
                                child: Text(
                                  "Set As Lock Screen",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                )),
                          ],
                        ))
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _setWallPaper() async {
    String url = widget.imgPath;
    int location = WallpaperManager
        .HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(url);
    await WallpaperManager.setWallpaperFromFile(file.path, location);
    Fluttertoast.showToast(
        msg: "Wallpaper Set",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xff1C1B1B).withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0);
    // Navigator.pop(context);
  }

  _setLockScreenWallPaper() async {
    String url = widget.imgPath;
    int location = WallpaperManager
        .LOCK_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(url);
    await WallpaperManager.setWallpaperFromFile(file.path, location);
    Fluttertoast.showToast(
        msg: "Lockscreen Wallpaper Set",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xff1C1B1B).withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0);
    // Navigator.pop(context);
  }
}
