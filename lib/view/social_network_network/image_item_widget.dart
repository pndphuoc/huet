import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class ImageItemWidget extends StatelessWidget {
  const ImageItemWidget({
    Key? key,
    required this.entity,
    required this.option,
    this.onTap,
  }) : super(key: key);

  final AssetEntity entity;
  final ThumbnailOption option;
  final GestureTapCallback? onTap;

  Widget buildContent(BuildContext context) {
    if (entity.type == AssetType.audio) {
      return const Center(
        child: Icon(Icons.audiotrack, size: 30),
      );
    }
    return _buildImageWidget(context, entity, option);
  }
  
  Widget _buildImageWidget(
      BuildContext context,
      AssetEntity entity,
      ThumbnailOption option,
      ) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: AssetEntityImage(
            entity,
            isOriginal: false,
            thumbnailSize: option.size,
            thumbnailFormat: option.format,
            fit: BoxFit.cover,
          ),
        ),
        (entity.type == AssetType.video) ? Positioned(
            bottom: 0,
            right: 0,
            child: Text("${entity.videoDuration.inMinutes.toString()}:${(entity.videoDuration.inSeconds)>=10?entity.videoDuration.inSeconds.toString(): "0" + entity.videoDuration.inSeconds.toString()}", style: GoogleFonts.readexPro(color: Colors.white, fontSize: 15),)):Container()
        /*PositionedDirectional(
          bottom: 4,
          start: 0,
          end: 0,
          child: Row(
            children: [
              if (entity.isFavorite)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                    size: 16,
                  ),
                ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (entity.isLivePhoto)
                      Container(
                        margin: const EdgeInsetsDirectional.only(end: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                          color: Theme.of(context).cardColor,
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    Icon(
                          () {
                        switch (entity.type) {
                          case AssetType.other:
                            return Icons.abc;
                          case AssetType.image:
                            return Icons.image;
                          case AssetType.video:
                            return Icons.video_file;
                          case AssetType.audio:
                            return Icons.audiotrack;
                        }
                      }(),
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),*/
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: buildContent(context),
    );
  }
}