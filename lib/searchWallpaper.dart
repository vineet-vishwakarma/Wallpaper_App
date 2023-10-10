import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/config.dart';
import 'package:wallpaper_app/fullscreen.dart';

// ignore: camel_case_types
class searchWallpaper extends StatefulWidget {
  final String query;
  const searchWallpaper({super.key, required this.query});

  @override
  State<searchWallpaper> createState() => _searchWallpaperState();
}

// ignore: camel_case_types
class _searchWallpaperState extends State<searchWallpaper> {
  TextEditingController query = TextEditingController();
  List images = [];
  int page = 1;
  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  fetchApi() async {
    await http.get(
        Uri.parse(
            'https://api.pexels.com/v1/search?query=${widget.query}&per_page=80'),
        headers: {
          'Authorization':
              Config.apiKey
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
    });
  }

  loadMore() async {
    setState(() {
      page++;
    });
    String url =
        'https://api.pexels.com/v1/search?query=${widget.query}&per_page=80&page=$page';
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          'J0yI0Jok5Ex9lQHhsFqWV8E30RHtJrMJ7kPlKHhegr3BXH2wcIc7HcFp'
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          // centerTitle: true,
          title: Image.asset("assets/vertical_logo.png",height: 100,),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: Colors.black,
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 16.0, left: 50, right: 0),
                        child: SearchBar(
                          hintText: widget.query,
                          hintStyle: const MaterialStatePropertyAll(
                              TextStyle(color: Colors.white30)),
                          controller: query,
                          side: const MaterialStatePropertyAll(
                            BorderSide(
                              width: 10,
                            ),
                          ),
                          padding: const MaterialStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 14)),
                          backgroundColor: const MaterialStatePropertyAll(
                              Color.fromARGB(255, 49, 49, 49)),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: InkWell(
                            onTap: () {
                              query.text != ''
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            searchWallpaper(query: query.text),
                                      ),
                                    )
                                  : showDialog(
                                      context: context,
                                      builder: (_) => CupertinoAlertDialog(
                                        title: const Text('Nothing Searched'),
                                        content: const Text('Search Something'),
                                        actions: [
                                          CupertinoActionSheet(
                                            cancelButton: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Close')),
                                          ),
                                        ],
                                      ),
                                    );
                            },
                            child: const Icon(
                              Icons.search,
                              size: 35,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: GridView.builder(
                  itemCount: images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      childAspectRatio: 2 / 3,
                      mainAxisSpacing: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FullScreen(
                                      imageurl: images[index]['src']['large2x'],
                                    )));
                      },
                      child: Container(
                        color: Colors.white,
                        child: Image.network(
                          images[index]['src']['tiny'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            InkWell(
              onTap: () => loadMore(),
              child: Container(
                height: 60,
                width: double.infinity,
                color: Colors.black,
                child: Center(
                  child: Text(
                    'Load More',
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
            )
          ],
        ),
      ),
    );
  }
}
