import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'cacher.dart';
import 'device_info.dart';
import 'post_data.dart';
import 'poster.dart';
import 'utils.dart';

class FlutterArgus {
  static const MethodChannel _channel = const MethodChannel('flutter_argus');

  static FlutterArgus _instance;

  static Future<FlutterArgus> getInstance({String project}) async {
    if (_instance == null) {
      if (project == null || project.isEmpty)
        throw ArgumentError.notNull("project");
      PostData.project = project;
      await _initModules();

      _instance = FlutterArgus._();
    }
    return _instance;
  }

  static Future<void> _initModules() async {
    await initScreenInfo();
    PostData.copyWith(await getInfo());
    PostData.mid = await Utils.getMid(
        PostData.osid, PostData.project, PostData.pkn);
    await Cacher.init();
    sendAllCached();
  }

  static Future<void> sendAllCached() async {
    final all = await Cacher.getAllCached();
    if (all.length == 0) return;
    all.forEach((i) async {
      final id = i["logid"];
      final success = await Poster.send(i);
      if (success) {
        await Cacher.delete(id);
      }
    });
  }

  FlutterArgus._();

  Future<void> event(String name, {Map<String, dynamic> params}) async {
    final data = PostData(name: name, eventParam: params);
    print(json.encode(data));
    await Cacher.cache(data);
    final success = await Poster.send(data.toJson());
    if (success) {
      await Cacher.delete(data.id);
    }
  }

  static Future<Map<String,String>> getInfo()async{
    return await _channel.invokeMapMethod<String,String>("getInfo");
  }
}
