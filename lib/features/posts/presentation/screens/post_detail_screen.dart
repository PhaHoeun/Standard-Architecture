import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/frosted_container.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/post_detail_controller.dart';
import '../widgets/author_card.dart';
import '../widgets/comment_tile.dart';

class PostDetailScreen extends ConsumerWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(postDetailControllerProvider(postId));
    final isFavorite = ref.watch(favoritesControllerProvider).contains(postId);
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
              title: Text('Post #$postId'),
              actions: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                    color: isFavorite ? const Color(0xFF2563EB) : null,
                  ),
                  tooltip: isFavorite ? 'Remove from saved' : 'Save post',
                  onPressed: () {
                    ref.read(favoritesControllerProvider.notifier).toggleFavorite(postId);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: () {
                    ref.read(postDetailControllerProvider(postId).notifier).refresh();
                  },
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
        color: isDark ? const Color(0xFF2563EB).withValues(alpha: 0.9) : const Color(0xFF0F172A).withValues(alpha: 0.9),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1,
        ),
        onTap: () => _showAddCommentSheet(context, ref),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add_comment_rounded, size: 17, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Add Comment',
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
        child: detailAsync.when(
          data: (detail) {
            final post = detail.post;
            final author = detail.author;
            final comments = detail.comments;

            return RefreshIndicator(
              onRefresh: () => ref.read(postDetailControllerProvider(postId).notifier).refresh(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 100, 18, 100),
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF3B82F6).withValues(alpha: 0.18)
                              : const Color(0xFF0F172A).withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'ARTICLE #${post.id}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    post.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (author != null) ...[
                    AuthorCard(author: author),
                    const SizedBox(height: 18),
                  ],
                  FrostedContainer(
                    padding: const EdgeInsets.all(20),
                    borderRadius: 18,
                    blur: 14,
                    child: Text(
                      post.body,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 15.5,
                        height: 1.65,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Discussion (${comments.length})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (comments.isEmpty)
                    FrostedContainer(
                      padding: const EdgeInsets.all(24),
                      child: const Center(
                        child: Text('No comments yet. Be the first to share your thoughts!'),
                      ),
                    )
                  else
                    ...comments.map((comment) => CommentTile(comment: comment)),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: FrostedContainer(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    Text('Error loading post details', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(err.toString(), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.read(postDetailControllerProvider(postId).notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddCommentSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _AddCommentSheet(postId: postId),
    );
  }
}

class _AddCommentSheet extends ConsumerStatefulWidget {
  final int postId;

  const _AddCommentSheet({required this.postId});

  @override
  ConsumerState<_AddCommentSheet> createState() => _AddCommentSheetState();
}

class _AddCommentSheetState extends ConsumerState<_AddCommentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(postDetailControllerProvider(widget.postId).notifier).addComment(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            body: _bodyController.text.trim(),
          );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment published!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add comment: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            color: isDark
                ? const Color(0xFF0F172A).withValues(alpha: 0.88)
                : Colors.white.withValues(alpha: 0.90),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Add a Comment',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Your Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => v == null || !v.contains('@') ? 'Valid email required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _bodyController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Your message',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Comment is required' : null,
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Post Comment', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
