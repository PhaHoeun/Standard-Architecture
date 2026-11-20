// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreatePostController)
final createPostControllerProvider = CreatePostControllerProvider._();

final class CreatePostControllerProvider
    extends $AsyncNotifierProvider<CreatePostController, void> {
  CreatePostControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createPostControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createPostControllerHash();

  @$internal
  @override
  CreatePostController create() => CreatePostController();
}

String _$createPostControllerHash() =>
    r'e95fe03fe9923fc323a6e13f3a1f504d0edeec7e';

abstract class _$CreatePostController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
