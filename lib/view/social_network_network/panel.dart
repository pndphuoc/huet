import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_t/view/social_network_network/create_post.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:hue_t/colors.dart' as colors;

typedef void AlbumCallback(AssetPathEntity val);

class Panel extends StatefulWidget {
  final ScrollController controller;
  final PanelController panelController;
  final List<AssetPathEntity> albums;
  final AlbumCallback callback;

  Panel(
      {Key? key,
      required this.controller,
      required this.panelController,
      required this.albums,
      required this.callback})
      : super(key: key);

  @override
  State<Panel> createState() => _PanelState();
}

class _PanelState extends State<Panel> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Colors.grey,
            ),
          ]),
      child: Column(children: [
        Center(
          child: Icon(
            Icons.minimize_rounded,
            size: 30,
            color: colors.primaryColor,
          ),
        ),
        Expanded(
            child: ListView(
              controller: widget.controller,
              children: [
                ...widget.albums.map(
                      (e) => TextButton(
                      onPressed: () {
                        widget.panelController.close();
                        widget.callback(e);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        width: double.infinity,
                        child: Text(
                          e.name ?? "Untitled",
                          style: GoogleFonts.readexPro(
                              color: Colors.black, fontSize: 20),
                        ),
                      )),
                ),
                const SizedBox(height: 100,)
              ],
            ))
      ]),
    );
  }
}
