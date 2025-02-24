import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nowu/models/article.dart';

part 'explore_news_article_tile_state.freezed.dart';

enum ExploreNewsArticleTileLaunchingState {
  Static,
  Launching,
}

@freezed
sealed class ExploreNewsArticleTileState
    with _$ExploreNewsArticleTileState {
  const factory ExploreNewsArticleTileState({
    required NewsArticle newsArticle,
    required ExploreNewsArticleTileLaunchingState launchingState,
  }) = _ExploreNewsArticleTileState;
}
