import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pytorch_onnx_example/reddit_nlp/reddit_nlp_bloc.dart';
import 'package:flutter_pytorch_onnx_example/reddit_nlp/reddit_nlp_event.dart';
import 'package:flutter_pytorch_onnx_example/reddit_nlp/reddit_nlp_state.dart';

class RedditNLPPage extends StatefulWidget {
  @override
  _RedditNLPPageState createState() => _RedditNLPPageState();
}

class _RedditNLPPageState extends State<RedditNLPPage> {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RedditNLPBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Reddit NLP Model"),
        ),
        body: BlocBuilder<RedditNLPBloc, RedditNLPState>(
          builder: (context, state) {
            Widget loadingWidget = Center(
              child: CircularProgressIndicator(),
            );
            return state.modelLoadingState.when(
              none: () {
                BlocProvider.of<RedditNLPBloc>(context).add(
                    RedditNLPEvent.loadModel(
                        "models/model-reddit16-f140225004_2.pt1"));
                return loadingWidget;
              },
              loading: () => loadingWidget,
              error: (_) => Center(
                child: Text("Error Loading Model."),
              ),
              done: (_) => SingleChildScrollView(
                padding: EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: controller,
                      maxLines: 5,
                      minLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Text to infer...",
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        final text = controller.text;
                        if (text != null && text.isNotEmpty) {
                          BlocProvider.of<RedditNLPBloc>(context)
                              .add(RedditNLPEvent.inferText(text));
                        }
                      },
                      child: Text("Infer"),
                    ),
                    ...state.inferenceState.maybeWhen(
                        orElse: () => [],
                        done: (top5) {
                          return [
                            Card(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "Top 5 Results",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  ...top5
                                      .map((e) => ListTile(
                                            title: Text(e.className),
                                            subtitle: Text(e.score.toString()),
                                          ))
                                      .toList()
                                ],
                              ),
                            )
                          ];
                        })
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
