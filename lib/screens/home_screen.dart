import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_app/screens/video_detail_screen.dart';
import 'package:youtube_app/services/youtube_service.dart';
import 'package:youtube_app/utils/common.dart';

class HomeScreen extends StatefulWidget {
  final AppBar appBar;
  HomeScreen({this.appBar});
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 1;
  ScrollController _scrollController = new ScrollController();
  List _videos;
  YouTubeService _youTubeService;
  String _pageToken;
  @override
  void initState() {
    super.initState();
    _videos = [];
    _pageToken = '';
    _youTubeService = YouTubeService();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getVideos();
      }
    });
    _getVideos();
  }

  void _getVideos() async {
    _youTubeService.getVideos(pageToken: _pageToken).then((result) {
      Map<String, dynamic> jsonResponse = result;
      if (jsonResponse.containsKey("items") &&
          jsonResponse["items"].length > 0) {
        final List listData = jsonResponse["items"];
        List tempList = [];
        for (int i = 0; i < listData.length; i++) {
          tempList.add(listData[i]);
        }

        setState(() {
          //_videos = result["items"];
          page += 1;
          _pageToken = jsonResponse["nextPageToken"];
          _videos.addAll(tempList);
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
      controller: _scrollController,
      itemCount: _videos.length + 1,
      itemBuilder: (ctx, i) {
        if (i == _videos.length) {
          return _buildProgressIndicator();
        } else {
          return _videoItem(i);
        }
      },
    );
  }

  Widget _videoItem(i) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => VideoDetailScreen(
              video: _videos[i],
            ),
          ),
        );
      },
      child: Container(
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
                    backgroundImage: CachedNetworkImageProvider(
                        _videos[i]["snippet"]["thumbnails"]["default"]["url"]),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Common.cutString(_videos[i]["snippet"]["title"], 50),
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
                            Expanded(
                              child: Text(
                                _getDate(_videos[i]["snippet"]["publishedAt"]),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
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
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: 1.0,
          child: SizedBox(
            height: 20,
            width: 20,
            child: new CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  Widget _noData() {
    return Container(
      child: Center(
        child: Text("No hemos encontrado ningun video"),
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
