import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youtube_app/services/youtube_service.dart';
import 'package:youtube_app/utils/common.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _videos;
  YouTubeService _youTubeService;
  @override
  void initState() {
    super.initState();
    _videos = [];
    _youTubeService = YouTubeService();
    _getVideos();
  }

  void _getVideos() async {
    _youTubeService.getVideos().then((result) {
      print(result);
      if (result["items"].length > 0) {
        setState(() {
          _videos = result["items"];
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

  String _getDate(String dateStr) {
    DateTime date = Common.strToDateTime(dateStr);
    String formattedDate = Common.formatDate(date, "yyyy-MM-dd");
    return formattedDate;
  }

  Widget _listVideos() {
    return ListView.builder(
      itemCount: _videos.length,
      itemBuilder: (ctx, i) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Image.network(
                _videos[i]["snippet"]["thumbnails"]["medium"]["url"],
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(_videos[i]
                          ["snippet"]["thumbnails"]["default"]["url"]),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Common.cutString(
                                _videos[i]["snippet"]["title"], 70),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 2,
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                _videos[i]["snippet"]["channelTitle"],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                              Text(' - '),
                              Text(
                                _getDate(_videos[i]["snippet"]["publishTime"]),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          IconButton(
                            icon: Image.asset(
                              'assets/like.png',
                              height: 30,
                              width: 30,
                              color: Colors.blue,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            padding: EdgeInsets.only(top: 10),
                            icon: Image.asset(
                              'assets/dislike.png',
                              height: 26,
                              width: 26,
                              color: Colors.red,
                            ),
                            onPressed: () {},
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 4,
              )
            ],
          ),
        );
      },
    );
  }

  Widget _noData() {
    return Container(
      child: Center(
        child: Text("No hemos econtrado ningun video"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_videos.length > 0) ? _listVideos() : _noData(),
    );
  }
}
