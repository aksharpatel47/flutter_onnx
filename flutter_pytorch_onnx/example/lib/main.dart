import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_pytorch_onnx/flutter_pytorch_onnx.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class ClassScore {
  final String className;
  final double score;

  ClassScore(this.className, this.score);
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
      final modelName = "model-reddit16-f140225004_2.pt1";
      final assetPath = "models/$modelName";
      print("Start");
      print(await FlutterPytorchOnnx.loadModule(assetPath));
      print("Load Module");
      final moduleClasses = await FlutterPytorchOnnx.getModuleClasses();
      print(moduleClasses);
      final scores =
          await FlutterPytorchOnnx.analyzeText("I love playing games.");
      print(scores);

      final top5Classes = getTopKClasses(moduleClasses, scores, 5);
      for (var item in top5Classes) {
        print("${item.className} => ${item.score}");
      }
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  List<ClassScore> getTopKClasses(
      List<String> classes, List<double> scores, int k) {
    final classScores = List<ClassScore>();
    for (var i = 0; i < classes.length; i++) {
      classScores.add(ClassScore(classes[i], scores[i]));
    }

    classScores.sort((a, b) => -a.score.compareTo(b.score));

    return classScores.sublist(0, k);
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
