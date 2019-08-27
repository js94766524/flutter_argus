import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_argus/logger.dart';

import 'cacher.dart';
import 'device_info.dart';
import 'post_data.dart';
import 'poster.dart';
import 'utils.dart';

class FlutterArgus {
  static bool get printLog=> Logger.printLog;
  static set printLog(bool v)=>Logger.printLog = v;

  static const MethodChannel _channel = const MethodChannel('flutter_argus');

  static FlutterArgus _instance;

  static Future<FlutterArgus> getInstance({String project}) async {
    if (_instance == null) {
      if (project == null || project.isEmpty)
        throw ArgumentError.notNull("project");
      Logger.log("初始化FlutterArgus，项目名称：$project");
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
    Logger.log("发送缓存事件，共计${all.length}条");
    all.forEach((i) async {
      final id = i["logid"];
      Logger.log("发送事件[$id]");
      Logger.log(json.encode(i));
      final success = await Poster.send(i);
      if (success) {
        await Cacher.delete(id);
        Logger.log("[$id]事件发送成功，删除缓存数据");
      }else{
        Logger.log("[$id]事件发送失败");
      }
    });
  }

  FlutterArgus._();

  Future<void> event(String name, {Map<String, dynamic> params}) async {
    final data = PostData(name: name, eventParam: params);
    await Cacher.cache(data);
    Logger.log("发送事件[${data.id}]");
    Logger.log(json.encode(data));
    final success = await Poster.send(data.toJson());
    if (success) {
      await Cacher.delete(data.id);
      Logger.log("[${data.id}]事件发送成功，删除缓存数据");
    }else{
      Logger.log("[${data.id}]事件发送失败，存入缓存数据等待下次启动时重发");
    }
  }

  static Future<Map<String,String>> getInfo()async{
    return await _channel.invokeMapMethod<String,String>("getInfo");
  }
}
