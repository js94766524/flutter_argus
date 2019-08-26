import 'package:dio/dio.dart';

class Poster {
  static const url = "https://gather.oz-bigfoot.com/v2";
  static Dio dio = Dio();

  static Future<bool> send(Map<String,dynamic> data) async {
    try {
      final respond = await dio.post(url, data: data);
      if (respond.statusCode == 200) {
        return true;
      } else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
