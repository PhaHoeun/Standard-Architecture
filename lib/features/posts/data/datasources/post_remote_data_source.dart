import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

part 'post_remote_data_source.g.dart';

@riverpod
PostRemoteDataSource postRemoteDataSource(Ref ref) {
  final dio = ref.watch(dioProvider);
  return PostRemoteDataSource(dio: dio);
}

class PostRemoteDataSource {
  final Dio dio;

  PostRemoteDataSource({required this.dio});

  Future<List<PostModel>> fetchPosts() async {
    try {
      final response = await dio.get('/posts');
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data as List<dynamic>;
        return list
            .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network connection error');
    }
  }

  Future<PostModel> fetchPostById(int id) async {
    try {
      final response = await dio.get('/posts/$id');
      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network connection error');
    }
  }

  Future<UserModel> fetchAuthor(int userId) async {
    try {
      final response = await dio.get('/users/$userId');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network connection error');
    }
  }

  Future<List<CommentModel>> fetchComments(int postId) async {
    try {
      final response = await dio.get('/posts/$postId/comments');
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data as List<dynamic>;
        return list
            .map((item) => CommentModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network connection error');
    }
  }

  Future<PostModel> createPost({
    required String title,
    required String body,
    int userId = 1,
  }) async {
    try {
      final response = await dio.post(
        '/posts',
        data: {
          'title': title,
          'body': body,
          'userId': userId,
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return PostModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create post');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network connection error');
    }
  }

  Future<CommentModel> addComment({
    required int postId,
    required String name,
    required String email,
    required String body,
  }) async {
    try {
      final response = await dio.post(
        '/posts/$postId/comments',
        data: {
          'postId': postId,
          'name': name,
          'email': email,
          'body': body,
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return CommentModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to post comment');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network connection error');
    }
  }
}
