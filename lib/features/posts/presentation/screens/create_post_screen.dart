import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/frosted_container.dart';
import '../controllers/create_post_controller.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(createPostControllerProvider.notifier);
    final result = await controller.submitPost(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
    );

    if (mounted && result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post "${result.title}" published!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createPostControllerProvider);
    final isLoading = state.isLoading;
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
              title: const Text('Compose Post'),
            ),
          ),
        ),
      ),
      body: AmbientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FrostedContainer(
                    borderRadius: 16,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextFormField(
                      controller: _titleController,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Post Title',
                        border: InputBorder.none,
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Title is required' : null,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: FrostedContainer(
                      borderRadius: 18,
                      padding: const EdgeInsets.all(16),
                      child: TextFormField(
                        controller: _bodyController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: const TextStyle(fontSize: 15, height: 1.5),
                        decoration: const InputDecoration(
                          hintText: 'Share your thoughts, architectural insights, or updates...',
                          border: InputBorder.none,
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Content is required' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (state.hasError) ...[
                    Text(
                      state.error.toString(),
                      style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                  ],
                  FrostedContainer(
                    borderRadius: 16,
                    color: const Color(0xFF2563EB).withValues(alpha: 0.95),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    onTap: isLoading ? null : _submit,
                    child: Center(
                      child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.send_rounded, size: 18, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Publish Post',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                    ),
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
