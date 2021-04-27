import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youtube_app/utils/constants.dart';

class YouTubeService {
  Future getVideos() async {
    var url = Uri.parse(
        "$YOUTUBE_URL/search?channelId=$channedlId&part=snippet,id&order=date&key=$apiKey");
    return http.get(url,
        headers: {'Content-Type': 'application/json'}).then((_handleRequest));
  }

  void _handleRequest(response) {
    return json.decode(response.body);
  }
}
