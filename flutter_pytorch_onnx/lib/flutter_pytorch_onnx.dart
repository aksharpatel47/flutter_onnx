import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPytorchOnnx {
  static const MethodChannel _channel =
      const MethodChannel('flutter_pytorch_onnx');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> loadModule(String assetPath) async {
    return await _channel.invokeMethod("loadModule", [assetPath]);
  }

  static Future<List<String>> getModuleClasses() async {
    return await _channel.invokeListMethod<String>("getModuleClasses");
  }
}
