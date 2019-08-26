import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

class PostData {
  ///操作系统ID
  static String osid;

  ///客户端唯一ID
  static String mid;

  ///项目名称
  static String project;

  ///项目包名
  static String pkn = "";

  ///项目版本
  static String ver = "";

  ///项目版本号
  static String vcode = "";

  ///包构建时间
  static String build_ts = "";

  ///屏幕宽度
  static String resw = "";

  ///屏幕高度
  static String resh = "";

  ///屏幕像素密度
  static String density = "";

  static String brand = "";
  static String product = "";
  static String model = "";

  ///设备
  static String device = "";

  ///？？？
  static String mktname = "";

  ///手机系统版本
  static String api = "";

  ///操作系统名称
  static String osname = "";

  ///操作系统版本
  static String osver = "";

  ///网络运营商
  static String mno = "";

  ///时区
  static String timezone = "";

  ///语言
  static String lang = "";

  ///国家
  static String country = "";

  static void copyWith(Map<String, dynamic> map) {
    osid = map["osid"] ?? osid;
    build_ts = map["build_ts"] ?? build_ts;
    brand = map["brand"] ?? brand;
    model = map["model"] ?? model;
    mktname = map["mktname"] ?? mktname;
    device = map["device"] ?? device;
    product = map["product"] ?? product;
    osver = map["osver"] ?? osver;
    osname = map["osname"] ?? osname;
    api = map["api"] ?? api;
    pkn = map["pkn"] ?? pkn;
    ver = map["ver"] ?? ver;
    vcode = map["vcode"] ?? vcode;
    timezone = map["timezone"] ?? timezone;
    mno = map["mno"] ?? mno;
    lang = map["lang"] ?? lang;
  }

  ///事件ID
  String id = "";

  ///事件时间戳
  String timestamp = "";

  ///事件名称
  String name = "";

  ///事件参数
  Map<String, dynamic> params;

  PostData({String id, @required this.name, Map<String, dynamic> eventParam})
      : this.id = id ?? Uuid().v1(),
        timestamp = DateTime.now().millisecondsSinceEpoch.toString(),
        this.params = eventParam ?? <String, dynamic>{};

  void addParam(String key, dynamic value) {
    params[key] = value;
  }

  Map<String, dynamic> toJson() => {
        "mid": mid,
        "project": project,
        "pkn": pkn,
        "ver": ver,
        "vcode": vcode,
        "build_ts": build_ts,
        "resw": resw,
        "resh": resh,
        "density": density,
        "brand": brand,
        "product": product,
        "model": model,
        "device": device,
        "mktname": mktname,
        "api": api,
        "osname": osname,
        "osver": osver,
        "mno": mno,
        "timezone": timezone,
        "lang": lang,
        "country": country,
        "logid": id,
        "event_ts": timestamp,
        "event_name": name,
        "event_param": params.entries.map((kv) {
          return {
            "key": kv.key,
            "value": kv.value,
          };
        }).toList()
      };
}
