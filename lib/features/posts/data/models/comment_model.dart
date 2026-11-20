import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/comment.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
abstract class CommentModel with _$CommentModel {
  const CommentModel._();

  const factory CommentModel({
    required int id,
    required int postId,
    @Default('Anonymous') String name,
    @Default('') String email,
    @Default('') String body,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);

  Comment toEntity() => Comment(
        id: id,
        postId: postId,
        name: name,
        email: email,
        body: body,
      );
}
