// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostFilterOption)
final postFilterOptionProvider = PostFilterOptionProvider._();

final class PostFilterOptionProvider
    extends $NotifierProvider<PostFilterOption, PostFilter> {
  PostFilterOptionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postFilterOptionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postFilterOptionHash();

  @$internal
  @override
  PostFilterOption create() => PostFilterOption();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostFilter>(value),
    );
  }
}

String _$postFilterOptionHash() => r'7e4b23aece452af767778c665add1956f9d03a6c';

abstract class _$PostFilterOption extends $Notifier<PostFilter> {
  PostFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PostFilter, PostFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PostFilter, PostFilter>,
              PostFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PostSearchQuery)
final postSearchQueryProvider = PostSearchQueryProvider._();

final class PostSearchQueryProvider
    extends $NotifierProvider<PostSearchQuery, String> {
  PostSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postSearchQueryHash();

  @$internal
  @override
  PostSearchQuery create() => PostSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$postSearchQueryHash() => r'5652d5debf4a2cadb8f16ce9e0e3603360b5ebde';

abstract class _$PostSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PostsController)
final postsControllerProvider = PostsControllerProvider._();

final class PostsControllerProvider
    extends $AsyncNotifierProvider<PostsController, List<Post>> {
  PostsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsControllerHash();

  @$internal
  @override
  PostsController create() => PostsController();
}

String _$postsControllerHash() => r'9b173bbeebdf606ccab112d34425021c95c33409';

abstract class _$PostsController extends $AsyncNotifier<List<Post>> {
  FutureOr<List<Post>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Post>>, List<Post>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Post>>, List<Post>>,
              AsyncValue<List<Post>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredPosts)
final filteredPostsProvider = FilteredPostsProvider._();

final class FilteredPostsProvider
    extends $FunctionalProvider<List<Post>, List<Post>, List<Post>>
    with $Provider<List<Post>> {
  FilteredPostsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredPostsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredPostsHash();

  @$internal
  @override
  $ProviderElement<List<Post>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Post> create(Ref ref) {
    return filteredPosts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Post> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Post>>(value),
    );
  }
}

String _$filteredPostsHash() => r'dee8c493ef1b39985512a1f054eb47d0c7cdeb16';
