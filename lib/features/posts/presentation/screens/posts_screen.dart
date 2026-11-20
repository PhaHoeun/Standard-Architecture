import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/posts_controller.dart';
import '../widgets/post_card.dart';
import '../widgets/search_bar_widget.dart';

class PostsScreen extends ConsumerWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsControllerProvider);
    final filteredPostsList = ref.watch(filteredPostsProvider);
    final activeFilter = ref.watch(postFilterOptionProvider);
    final favoriteCount = ref.watch(favoritesControllerProvider).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Architecture Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh feed',
            onPressed: () => ref.read(postsControllerProvider.notifier).refresh(),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'My Profile',
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/create'),
        icon: const Icon(Icons.add),
        label: const Text('New Post'),
      ),
      body: Column(
        children: [
          const SearchBarWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All Posts'),
                  selected: activeFilter == PostFilter.all,
                  onSelected: (_) {
                    ref.read(postFilterOptionProvider.notifier).setFilter(PostFilter.all);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  avatar: const Icon(Icons.bookmark, size: 16),
                  label: Text('Saved ($favoriteCount)'),
                  selected: activeFilter == PostFilter.favoritesOnly,
                  onSelected: (_) {
                    ref.read(postFilterOptionProvider.notifier).setFilter(PostFilter.favoritesOnly);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: postsAsync.when(
              data: (_) {
                if (filteredPostsList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            activeFilter == PostFilter.favoritesOnly
                                ? Icons.bookmark_border
                                : Icons.search_off,
                            size: 48,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            activeFilter == PostFilter.favoritesOnly
                                ? 'No saved posts yet.'
                                : 'No posts match your search.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => ref.read(postsControllerProvider.notifier).refresh(),
                  child: ListView.builder(
                    itemCount: filteredPostsList.length,
                    itemBuilder: (context, index) {
                      return PostCard(post: filteredPostsList[index]);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off, size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(
                        'Could not load posts',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => ref.read(postsControllerProvider.notifier).refresh(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
