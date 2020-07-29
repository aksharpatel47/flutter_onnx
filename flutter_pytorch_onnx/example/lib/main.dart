import 'package:flutter/material.dart';
import 'package:flutter_pytorch_onnx_example/reddit_nlp/reddit_nlp_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PyTorch ONNX Demo",
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(
          builder: (context) => ListView(
            children: [
              ListTile(
                title: Text("Reddit NLP"),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RedditNLPPage()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
