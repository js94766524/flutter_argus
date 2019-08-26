import 'dart:ui';

import 'post_data.dart';

Future<void> initScreenInfo() async {
  PostData.density = window.devicePixelRatio.toString();
  PostData.resw = window.physicalSize.width.toStringAsFixed(0);
  PostData.resh = window.physicalSize.height.toStringAsFixed(0);
}

