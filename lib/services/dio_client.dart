import 'dart:io';

import 'package:dio/dio.dart';

class DioClient {
  static Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://www.googleapis.com/youtube/v3",
      // connectTimeout: 5000,
      // receiveTimeout: 5000,
      headers: {
        Headers.contentTypeHeader: ContentType.json,
      },
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );

  Dio get dio => _dio;
}
