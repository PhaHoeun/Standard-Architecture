import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../domain/entities/post.dart';
import 'posts_controller.dart';

part 'create_post_controller.g.dart';

@riverpod
class CreatePostController extends _$CreatePostController {
  @override
  FutureOr<void> build() {
    // Idle state
  }

  Future<Post?> submitPost({
    required String title,
    required String body,
  }) async {
    state = const AsyncLoading();

    Post? created;
    state = await AsyncValue.guard(() async {
      final repo = ref.read(postRepositoryProvider);
      created = await repo.createPost(title: title, body: body);
      ref.invalidate(postsControllerProvider);
    });

    return created;
  }
}
