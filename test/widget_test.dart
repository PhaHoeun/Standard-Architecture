import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:standard_architecture/features/posts/domain/entities/post.dart';
import 'package:standard_architecture/features/posts/presentation/controllers/posts_controller.dart';
import 'package:standard_architecture/features/posts/presentation/screens/posts_screen.dart';

void main() {
  testWidgets('PostsScreen renders search, filter chips, and post items', (WidgetTester tester) async {
    const mockPosts = [
      Post(id: 1, userId: 1, title: 'Sample Architecture Post', body: 'Sample content 1'),
      Post(id: 2, userId: 1, title: 'Another Deep Dive', body: 'Sample content 2'),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postsControllerProvider.overrideWith(() => MockPostsController(mockPosts)),
        ],
        child: const MaterialApp(
          home: PostsScreen(),
        ),
      ),
    );

    await tester.pump();

    // Verify UI components exist
    expect(find.text('Architecture Feed'), findsOneWidget);
    expect(find.text('All Posts'), findsOneWidget);
    expect(find.text('Saved (0)'), findsOneWidget);
    expect(find.text('Sample Architecture Post'), findsOneWidget);
    expect(find.text('Another Deep Dive'), findsOneWidget);
  });
}

class MockPostsController extends PostsController {
  final List<Post> initialPosts;
  MockPostsController(this.initialPosts);

  @override
  Future<List<Post>> build() async {
    return initialPosts;
  }
}
