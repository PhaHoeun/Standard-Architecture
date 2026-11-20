import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/post_detail.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_data_source.dart';
import '../models/comment_model.dart';
import '../models/user_model.dart';

part 'post_repository_impl.g.dart';

@riverpod
PostRepository postRepository(Ref ref) {
  final remoteDataSource = ref.watch(postRemoteDataSourceProvider);
  return PostRepositoryImpl(remoteDataSource: remoteDataSource);
}

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Post>> getPosts({String? query}) async {
    final models = await remoteDataSource.fetchPosts();
    var list = models.map((model) => model.toEntity()).toList();
    if (query != null && query.trim().isNotEmpty) {
      final lower = query.toLowerCase();
      list = list.where((p) => p.title.toLowerCase().contains(lower) || p.body.toLowerCase().contains(lower)).toList();
    }
    return list;
  }

  @override
  Future<PostDetail> getPostDetail(int id) async {
    final postModel = await remoteDataSource.fetchPostById(id);
    final post = postModel.toEntity();

    UserModel? userModel;
    List<CommentModel> commentModels = [];

    await Future.wait([
      (() async {
        try {
          userModel = await remoteDataSource.fetchAuthor(post.userId);
        } catch (_) {
          userModel = null;
        }
      })(),
      (() async {
        try {
          commentModels = await remoteDataSource.fetchComments(id);
        } catch (_) {
          commentModels = [];
        }
      })(),
    ]);

    return PostDetail(
      post: post,
      author: userModel?.toEntity(),
      comments: commentModels.map((c) => c.toEntity()).toList(),
    );
  }

  @override
  Future<Post> createPost({required String title, required String body}) async {
    final model = await remoteDataSource.createPost(title: title, body: body);
    return model.toEntity();
  }

  @override
  Future<Comment> addComment({
    required int postId,
    required String name,
    required String email,
    required String body,
  }) async {
    final model = await remoteDataSource.addComment(
      postId: postId,
      name: name,
      email: email,
      body: body,
    );
    return model.toEntity();
  }
}
