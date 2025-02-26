import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowu/assets/components/explore_tiles/bloc/explore_news_article_tile_state.dart';
import 'package:nowu/models/article.dart';
import 'package:nowu/services/causes_service.dart';

class ExploreNewsArticleTileBloc extends Cubit<ExploreNewsArticleTileState> {
  CausesService _causesService;

  ExploreNewsArticleTileBloc({
    required NewsArticle newsArticle,
    required CausesService causesService,
  })  : _causesService = causesService,
        super(
          ExploreNewsArticleTileState(
            newsArticle: newsArticle,
            launchingState: ExploreNewsArticleTileLaunchingState.Static,
          ),
        );

  Future<void> launchNewsArticle() async {
    switch (state.launchingState) {
      case ExploreNewsArticleTileLaunchingState.Static:
        {
          emit(
            state.copyWith(
              launchingState: ExploreNewsArticleTileLaunchingState.Launching,
            ),
          );

          await _causesService.completeNewsArticle(state.newsArticle);

          emit(
            state.copyWith(
              launchingState: ExploreNewsArticleTileLaunchingState.Static,
            ),
          );
        }
      case ExploreNewsArticleTileLaunchingState.Launching:
        {
          throw Exception('Learning resource already launching');
        }
    }
  }

  void markLaunched() async {
    emit(
      state.copyWith(
        launchingState: ExploreNewsArticleTileLaunchingState.Static,
      ),
    );
  }
}
