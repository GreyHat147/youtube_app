import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_panel_flutter/drag_listener.dart';
import 'package:flutter/material.dart';
import 'package:youtube_app/utils/common.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDetailScreen extends StatefulWidget {
  final DragListener listener;
  final Map video;
  VideoDetailScreen({this.video, this.listener});
  VideoDetailScreenState createState() => VideoDetailScreenState();
}

class VideoDetailScreenState extends State<VideoDetailScreen> {
  YoutubePlayerController _controller;
  bool _isPlayerReady;
  Map _video;

  @override
  void initState() {
    super.initState();
    //print(widget.video);
    _video = widget.video;
    _isPlayerReady = false;
    _controller = YoutubePlayerController(
      initialVideoId: widget.video["id"],
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        controlsVisibleAtStart: true,
        //forceHD: true,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      //
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _showVideoPlayer() {
    return Container(
      height: 300,
      child: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        onReady: () {
          print('Player is ready.');
          _isPlayerReady = true;
          setState(() {});
        },
      ),
    );
  }

  Widget _body() {
    return Container(
      width: MediaQuery.of(context).size.width,
      //padding: EdgeInsets.all(15),
      child: ListView(
        //shrinkWrap: true,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _video["snippet"]["title"],
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                Text(
                  "${Common.roundNumber(_video["statistics"]["viewCount"])} views",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Image.asset(
                        'assets/like_y.png',
                        color: Colors.grey[600],
                        height: 22,
                        width: 22,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        Common.roundNumber(_video["statistics"]["likeCount"]),
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    )
                  ],
                ),
                onPressed: () {},
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Image.asset(
                        'assets/dislike_y.png',
                        color: Colors.grey[600],
                        height: 22,
                        width: 22,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        Common.roundNumber(
                            _video["statistics"]["dislikeCount"]),
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    )
                  ],
                ),
                onPressed: () {},
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Icon(
                        Icons.share,
                        color: Colors.grey[600],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Share',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    )
                  ],
                ),
                onPressed: () {},
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Icon(
                        Icons.file_download,
                        color: Colors.grey[600],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Download',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    )
                  ],
                ),
                onPressed: () {},
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Icon(
                        Icons.library_add,
                        color: Colors.grey[600],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Add to',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    )
                  ],
                ),
                onPressed: () {},
              ),
            ],
          ),
          Divider(thickness: 1),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      _video["snippet"]["thumbnails"]["medium"]["url"]),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: Text(
                    _video["snippet"]["channelTitle"],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.video_collection,
                    color: Colors.red,
                  ),
                  label: Text(
                    "SUBSCRIBE",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 1),
          Container(
            padding: EdgeInsets.all(15),
            child: Text(
              _video["snippet"]["description"] ?? "No description",
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
/*             (_isPlayerReady)
                ? _showVideoPlayer()
                : Container(
                    height: 220,
                    child: Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ), */
            _showVideoPlayer(),
            Flexible(child: _body()),
          ],
        ),
      ),
    );
  }
}
