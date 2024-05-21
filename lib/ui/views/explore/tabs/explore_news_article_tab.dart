import 'package:flutter/material.dart';
import 'package:nowu/assets/components/explore_tiles.dart';
import 'package:nowu/locator.dart';
import 'package:nowu/services/search_service.dart';

import '../bloc/tabs/explore_news_article_tab_bloc.dart';
import '../explore_page_viewmodel.dart';
import '../filters/explore_filter_chip.dart';
import 'explore_tab.dart';

class ExploreNewsArticleTab extends StatelessWidget {
  final ExplorePageViewModel viewModel;

  const ExploreNewsArticleTab(this.viewModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExploreTab(
      createBloc: (context) =>
          ExploreNewsArticleTabBloc(searchService: locator<SearchService>()),
      filterChips: [
        const CausesFilter(),
        const CompletedFilter(),
      ],
      itemBuilder: (newsArticle) => Container(
        // TODO Create shared constant for these/ pull. from ExploreSectionArgs
        height: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ExploreNewsArticleTile(
            NewsArticleExploreTileData(newsArticle),
          ),
        ),
      ),
    );
  }
}
