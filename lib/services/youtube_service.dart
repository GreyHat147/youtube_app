import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youtube_app/utils/constants.dart';

final JsonDecoder _decoder = new JsonDecoder();

class YouTubeService {
  Future getVideos({pageToken = ''}) async {
    var url = Uri.parse(
        "https://youtube.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails%2Cstatistics&chart=mostPopular&pageToken=$pageToken&regionCode=CO&key=$apiKey");

    print(url);
    return http.get(url,
        headers: {'Content-Type': 'application/json'}).then((_handleRequest));
  }

  _handleRequest(http.Response response) {
    //final String res = response.body;
    final int statusCode = response.statusCode;
    //print('Code: $statusCode Response $res');

    String body = utf8.decode(response.bodyBytes);
    if (statusCode < 200 || statusCode >= 400 || json == null) {
      return _decoder.convert(body);
    }
    return _decoder.convert(body);
  }
}
