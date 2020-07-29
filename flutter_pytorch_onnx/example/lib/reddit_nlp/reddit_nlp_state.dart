import 'package:flutter_pytorch_onnx_example/common/class_score.dart';
import 'package:flutter_pytorch_onnx_example/common/loading_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reddit_nlp_state.freezed.dart';

@freezed
abstract class RedditNLPState with _$RedditNLPState {
  const factory RedditNLPState([
    String predictionText,
    List<String> classes,
    @Default(LoadingState.none()) LoadingState<bool> modelLoadingState,
    @Default(LoadingState.none()) LoadingState<List<ClassScore>> inferenceState,
  ]) = _RedditNLPState;
}
