import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pytorch_onnx/flutter_pytorch_onnx.dart';
import 'package:flutter_pytorch_onnx_example/common/class_score.dart';
import 'package:flutter_pytorch_onnx_example/common/loading_status.dart';
import 'package:flutter_pytorch_onnx_example/reddit_nlp/reddit_nlp_event.dart';
import 'package:flutter_pytorch_onnx_example/reddit_nlp/reddit_nlp_state.dart';

class RedditNLPBloc extends Bloc<RedditNLPEvent, RedditNLPState> {
  RedditNLPBloc() : super(RedditNLPState());

  List<ClassScore> _getTopKClasses(
      List<String> classes, List<double> scores, int k) {
    final classScores = List<ClassScore>();
    for (var i = 0; i < classes.length; i++) {
      classScores.add(ClassScore(classes[i], scores[i]));
    }

    classScores.sort((a, b) => -a.score.compareTo(b.score));

    return classScores.sublist(0, k);
  }

  @override
  Stream<RedditNLPState> mapEventToState(RedditNLPEvent event) async* {
    yield* event.when(
      loadModel: (modelAssetName) async* {
        yield state.copyWith(modelLoadingState: LoadingState.loading());
        await Torch.loadModule(modelAssetName);
        final classes = await Torch.getModuleClasses();
        yield state.copyWith(
          modelLoadingState: LoadingState.done(true),
          classes: classes,
        );
      },
      inferText: (text) async* {
        yield state.copyWith(inferenceState: LoadingState.loading());
        final scores = await Torch.analyzeText(text);
        final top5Classes = _getTopKClasses(state.classes, scores, 5);
        yield state.copyWith(
          inferenceState: LoadingState.done(top5Classes),
          predictionText: text,
        );
      },
    );
  }
}
