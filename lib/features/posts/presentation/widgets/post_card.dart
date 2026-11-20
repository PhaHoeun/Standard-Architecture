import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/frosted_container.dart';
import '../../domain/entities/post.dart';
import '../controllers/favorites_controller.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isFavorite = ref.watch(favoritesControllerProvider).contains(post.id);

    return FrostedContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
      padding: const EdgeInsets.all(18.0),
      borderRadius: 20,
      blur: 16,
      onTap: () => context.go('/posts/${post.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3B82F6).withValues(alpha: 0.18)
                      : const Color(0xFF0F172A).withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '#${post.id}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  post.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    isFavorite ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                    key: ValueKey(isFavorite),
                    size: 22,
                    color: isFavorite
                        ? const Color(0xFF2563EB)
                        : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                  ),
                ),
                onPressed: () {
                  ref.read(favoritesControllerProvider.notifier).toggleFavorite(post.id);
                },
                tooltip: isFavorite ? 'Remove from saved' : 'Save post',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            post.body,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.55,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 13,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Article',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Text(
                    'Read more',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 13,
                    color: Color(0xFF2563EB),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
