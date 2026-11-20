// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostDetailController)
final postDetailControllerProvider = PostDetailControllerFamily._();

final class PostDetailControllerProvider
    extends $AsyncNotifierProvider<PostDetailController, PostDetail> {
  PostDetailControllerProvider._({
    required PostDetailControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'postDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postDetailControllerHash();

  @override
  String toString() {
    return r'postDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PostDetailController create() => PostDetailController();

  @override
  bool operator ==(Object other) {
    return other is PostDetailControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postDetailControllerHash() =>
    r'40a195d97d822dcd9f51cda620bd63cfde0566cb';

final class PostDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PostDetailController,
          AsyncValue<PostDetail>,
          PostDetail,
          FutureOr<PostDetail>,
          int
        > {
  PostDetailControllerFamily._()
    : super(
        retry: null,
        name: r'postDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostDetailControllerProvider call(int postId) =>
      PostDetailControllerProvider._(argument: postId, from: this);

  @override
  String toString() => r'postDetailControllerProvider';
}

abstract class _$PostDetailController extends $AsyncNotifier<PostDetail> {
  late final _$args = ref.$arg as int;
  int get postId => _$args;

  FutureOr<PostDetail> build(int postId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PostDetail>, PostDetail>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PostDetail>, PostDetail>,
              AsyncValue<PostDetail>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
