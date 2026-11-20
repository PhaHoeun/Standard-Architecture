import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/post.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class PostModel with _$PostModel {
  const PostModel._();

  const factory PostModel({
    required int id,
    required int userId,
    required String title,
    @Default('') String body,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

  Post toEntity() => Post(
        id: id,
        userId: userId,
        title: title,
        body: body,
      );
}
