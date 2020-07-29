import 'package:freezed_annotation/freezed_annotation.dart';

part 'loading_status.freezed.dart';

@freezed
abstract class LoadingState<T> with _$LoadingState<T> {
  const factory LoadingState.none() = _None<T>;
  const factory LoadingState.loading() = _Loading<T>;
  const factory LoadingState.error(String errorMessage) = _Error<T>;
  const factory LoadingState.done(T data) = _Done<T>;
}
