import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:open_app_file/open_app_file.dart';

class FullScreen extends StatefulWidget {
  final String imageurl;
  const FullScreen({
    super.key,
    required this.imageurl,
  });

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  Future<void> setWallpaper(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(child: Text('Set Wallpaper is processing...'))));
    int location = WallpaperManager.HOME_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(widget.imageurl);
    // final bool result =
    await WallpaperManager.setWallpaperFromFile(file.path, location);
  }

  Future<void> downloadWallpaper(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Center(child: Text('Downloading...'))));

    var time = DateTime.now().millisecondsSinceEpoch;
    var path = "/storage/emulated/0/Download/image-$time.jpg";
    var file = File(path);
    var res = await get(Uri.parse(widget.imageurl));
    file.writeAsBytes(res.bodyBytes);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Downloaded Successfully ✅'),
      action: SnackBarAction(
          label: "Open",
          onPressed: () {
            OpenAppFile.open(path);
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Image.network(
                          widget.imageurl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          onPressed: () => downloadWallpaper(context),
                          elevation: 10,
                          backgroundColor: Colors.black,
                          tooltip: 'Download Image',
                          child: const Icon(
                            Icons.download,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setWallpaper(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Align(
                          alignment: Alignment.center,
                          child: Text('Wallpaper Set Successfully ✅'))));
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      'Set Wallpaper',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
