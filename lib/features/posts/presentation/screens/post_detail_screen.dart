import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Post #$postId'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: isFavorite ? theme.colorScheme.primary : null,
            ),
            tooltip: isFavorite ? 'Remove from saved' : 'Save post',
            onPressed: () {
              ref.read(favoritesControllerProvider.notifier).toggleFavorite(postId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(postDetailControllerProvider(postId).notifier).refresh();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_comment),
        label: const Text('Add Comment'),
        onPressed: () => _showAddCommentSheet(context, ref),
      ),
      body: detailAsync.when(
        data: (detail) {
          final post = detail.post;
          final author = detail.author;
          final comments = detail.comments;

          return RefreshIndicator(
            onRefresh: () => ref.read(postDetailControllerProvider(postId).notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                Text(
                  post.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (author != null) ...[
                  AuthorCard(author: author),
                  const SizedBox(height: 16),
                ],
                Text(
                  post.body,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comments (${comments.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (comments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(child: Text('No comments yet. Be the first to reply!')),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
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
    );
  }

  void _showAddCommentSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
          const SnackBar(content: Text('Comment added successfully!')),
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
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add a Comment',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Your Name', border: OutlineInputBorder()),
              validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
              validator: (v) => v == null || !v.contains('@') ? 'Valid email required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bodyController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Comment', border: OutlineInputBorder()),
              validator: (v) => v == null || v.trim().isEmpty ? 'Comment is required' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Post Comment'),
            ),
          ],
        ),
      ),
    );
  }
}
