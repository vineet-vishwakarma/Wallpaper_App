import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key});

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
              'Wallpaper App',
              style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: GridView.builder(
                  itemCount: 80,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      childAspectRatio: 2 / 3,
                      mainAxisSpacing: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),
            Container(
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
            )
          ],
        ),
      ),
    );
  }
}
