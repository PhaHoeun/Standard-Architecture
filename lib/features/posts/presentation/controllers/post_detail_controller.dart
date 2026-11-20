import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../domain/entities/post_detail.dart';

part 'post_detail_controller.g.dart';

@riverpod
class PostDetailController extends _$PostDetailController {
  @override
  FutureOr<PostDetail> build(int postId) async {
    final repository = ref.watch(postRepositoryProvider);
    return repository.getPostDetail(postId);
  }

  Future<void> addComment({
    required String name,
    required String email,
    required String body,
  }) async {
    final repository = ref.read(postRepositoryProvider);

    final newComment = await repository.addComment(
      postId: postId,
      name: name,
      email: email,
      body: body,
    );

    final current = state.value;
    if (current != null) {
      state = AsyncData(
        current.copyWith(
          comments: [newComment, ...current.comments],
        ),
      );
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      final repository = ref.read(postRepositoryProvider);
      return repository.getPostDetail(postId);
    });
  }
}
