import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Torch {
  static const MethodChannel _channel =
      const MethodChannel('flutter_pytorch_onnx');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> loadModule(String assetPath) async {
    String updatedAssetPath = assetPath;
    if (Platform.isAndroid) {
      final asset = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      final file =
          File(tempDir.absolute.path + "/${assetPath.split("/").last}");
      final doesFileExist = await file.exists();
      if (!doesFileExist) {
        file.writeAsBytes(
            asset.buffer.asUint8List(asset.offsetInBytes, asset.lengthInBytes));
      }
      updatedAssetPath = file.absolute.path;
    }

    return await _channel.invokeMethod("loadModule", [updatedAssetPath]);
  }

  static Future<List<String>> getModuleClasses() async {
    return await _channel.invokeListMethod<String>("getModuleClasses");
  }

  static Future<List<double>> analyzeText(String text) async {
    return await _channel.invokeListMethod<double>("analyzeText", [text]);
  }
}
