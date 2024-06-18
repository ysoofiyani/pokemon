import 'dart:developer';

import 'package:dio/dio.dart';

class HttpService {
  final _dio = Dio();

  Future<Response?> get(String path) async {
    try {
      Response res = await _dio.get(path);
      return res;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
