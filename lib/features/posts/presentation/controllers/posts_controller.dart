import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../domain/entities/post.dart';
import 'favorites_controller.dart';

part 'posts_controller.g.dart';

enum PostFilter { all, favoritesOnly }

@riverpod
class PostFilterOption extends _$PostFilterOption {
  @override
  PostFilter build() => PostFilter.all;

  void setFilter(PostFilter filter) => state = filter;
}

@riverpod
class PostSearchQuery extends _$PostSearchQuery {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

@riverpod
class PostsController extends _$PostsController {
  @override
  FutureOr<List<Post>> build() async {
    return _fetchPosts();
  }

  Future<List<Post>> _fetchPosts() async {
    final repository = ref.watch(postRepositoryProvider);
    return repository.getPosts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPosts());
  }
}

@riverpod
List<Post> filteredPosts(Ref ref) {
  final postsAsync = ref.watch(postsControllerProvider);
  final query = ref.watch(postSearchQueryProvider).toLowerCase().trim();
  final filter = ref.watch(postFilterOptionProvider);
  final favorites = ref.watch(favoritesControllerProvider);

  return postsAsync.maybeWhen(
    data: (posts) {
      return posts.where((post) {
        final matchesQuery = query.isEmpty ||
            post.title.toLowerCase().contains(query) ||
            post.body.toLowerCase().contains(query);

        final matchesFavorite = filter == PostFilter.all || favorites.contains(post.id);

        return matchesQuery && matchesFavorite;
      }).toList();
    },
    orElse: () => [],
  );
}
