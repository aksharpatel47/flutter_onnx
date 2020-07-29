import 'package:freezed_annotation/freezed_annotation.dart';

part 'reddit_nlp_event.freezed.dart';

@freezed
abstract class RedditNLPEvent with _$RedditNLPEvent {
  const factory RedditNLPEvent.loadModel(String modelAssetName) = LoadModel;
  const factory RedditNLPEvent.inferText(String text) = InferText;
}
