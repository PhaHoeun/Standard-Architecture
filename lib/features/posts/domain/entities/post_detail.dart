import 'comment.dart';
import 'post.dart';
import 'user.dart';

class PostDetail {
  final Post post;
  final User? author;
  final List<Comment> comments;

  const PostDetail({
    required this.post,
    this.author,
    this.comments = const [],
  });

  PostDetail copyWith({
    Post? post,
    User? author,
    List<Comment>? comments,
  }) {
    return PostDetail(
      post: post ?? this.post,
      author: author ?? this.author,
      comments: comments ?? this.comments,
    );
  }
}
