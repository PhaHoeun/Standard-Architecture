import '../entities/comment.dart';
import '../entities/post.dart';
import '../entities/post_detail.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts({String? query});
  Future<PostDetail> getPostDetail(int id);
  Future<Post> createPost({required String title, required String body});
  Future<Comment> addComment({
    required int postId,
    required String name,
    required String email,
    required String body,
  });
}
