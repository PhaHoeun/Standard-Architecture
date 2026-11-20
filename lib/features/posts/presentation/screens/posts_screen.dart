import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/frosted_container.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              backgroundColor: isDark
                  ? const Color(0xFF090D16).withValues(alpha: 0.65)
                  : Colors.white.withValues(alpha: 0.6),
              elevation: 0,
              scrolledUnderElevation: 0,
              title: const Text('Architecture Feed'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Refresh feed',
                  onPressed: () => ref.read(postsControllerProvider.notifier).refresh(),
                ),
                IconButton(
                  icon: const Icon(Icons.account_circle_outlined),
                  tooltip: 'My Profile',
                  onPressed: () => context.go('/profile'),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FrostedContainer(
        borderRadius: 30,
        blur: 16,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        color: isDark
            ? const Color(0xFF2563EB).withValues(alpha: 0.85)
            : const Color(0xFF0F172A).withValues(alpha: 0.9),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1,
        ),
        onTap: () => context.go('/create'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.edit_outlined, size: 18, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'New Post',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
      body: AmbientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SearchBarWidget(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  children: [
                    _FilterTab(
                      label: 'All Posts',
                      isSelected: activeFilter == PostFilter.all,
                      onTap: () {
                        ref.read(postFilterOptionProvider.notifier).setFilter(PostFilter.all);
                      },
                    ),
                    const SizedBox(width: 8),
                    _FilterTab(
                      label: 'Saved ($favoriteCount)',
                      icon: Icons.bookmark_rounded,
                      isSelected: activeFilter == PostFilter.favoritesOnly,
                      onTap: () {
                        ref.read(postFilterOptionProvider.notifier).setFilter(PostFilter.favoritesOnly);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: postsAsync.when(
                  data: (_) {
                    if (filteredPostsList.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FrostedContainer(
                                borderRadius: 50,
                                blur: 16,
                                padding: const EdgeInsets.all(20),
                                child: Icon(
                                  activeFilter == PostFilter.favoritesOnly
                                      ? Icons.bookmark_border_rounded
                                      : Icons.search_off_rounded,
                                  size: 40,
                                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                activeFilter == PostFilter.favoritesOnly
                                    ? 'No saved posts yet.'
                                    : 'No posts match your search.',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => ref.read(postsControllerProvider.notifier).refresh(),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 4, bottom: 96),
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
                      padding: const EdgeInsets.all(28.0),
                      child: FrostedContainer(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.cloud_off_rounded, size: 44, color: Colors.redAccent),
                            const SizedBox(height: 12),
                            Text('Could not load posts', style: theme.textTheme.titleMedium),
                            const SizedBox(height: 6),
                            Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton.icon(
                              onPressed: () => ref.read(postsControllerProvider.notifier).refresh(),
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF2563EB) : const Color(0xFF0F172A))
              : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.65)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? Colors.white.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.8)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
