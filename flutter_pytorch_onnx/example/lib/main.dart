import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_pytorch_onnx/flutter_pytorch_onnx.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterPytorchOnnx.platformVersion;
      final tempDir = await getTemporaryDirectory();
      final modelName = "model-reddit16-f140225004_2.pt1";
      final asset = await rootBundle.load("models/$modelName");
      final file = File(tempDir.absolute.path + "/$modelName");
      final doesFileExist = await file.exists();
      if (!doesFileExist) {
        file.writeAsBytes(
            asset.buffer.asUint8List(asset.offsetInBytes, asset.lengthInBytes));
      }
      await FlutterPytorchOnnx.loadModule(file.absolute.path);
      final moduleClasses = await FlutterPytorchOnnx.getModuleClasses();
      print(moduleClasses);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
