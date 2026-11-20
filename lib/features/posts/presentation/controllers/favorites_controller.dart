import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorites_controller.g.dart';

@riverpod
class FavoritesController extends _$FavoritesController {
  @override
  Set<int> build() {
    return {};
  }

  void toggleFavorite(int postId) {
    if (state.contains(postId)) {
      state = {...state}..remove(postId);
    } else {
      state = {...state, postId};
    }
  }

  bool isFavorite(int postId) {
    return state.contains(postId);
  }
}
