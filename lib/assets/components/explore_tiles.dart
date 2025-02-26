import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nowu/assets/components/card.dart';
import 'package:nowu/assets/components/cause_indicator.dart';
import 'package:nowu/assets/components/custom_network_image.dart';
import 'package:nowu/assets/components/explore_tiles/bloc/explore_learning_resource_tile_bloc.dart';
import 'package:nowu/assets/components/explore_tiles/bloc/explore_learning_resource_tile_state.dart';
import 'package:nowu/assets/components/explore_tiles/bloc/explore_news_article_tile_bloc.dart';
import 'package:nowu/assets/components/explore_tiles/bloc/explore_news_article_tile_state.dart';
import 'package:nowu/locator.dart';
import 'package:nowu/models/article.dart';
import 'package:nowu/router.gr.dart';
import 'package:nowu/services/causes_service.dart';
import 'package:nowu/ui/components/user_progress/bloc/user_progress_bloc.dart';
import 'package:nowu/ui/components/user_progress/bloc/user_progress_state.dart';
import 'package:nowu/utils/let.dart';
import 'package:url_launcher/url_launcher.dart';

enum ExploreTileStyle {
  Standard,
}

abstract class ExploreTile extends StatelessWidget {
  ExploreTile({key});

  Widget buildBody(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      buildBody(context),
    );
  }
}

class ExploreCampaignTile extends ExploreTile {
  final String headerImage;
  final String title;
  final Cause cause;
  final ListCampaign campaign;

  ExploreCampaignTile(
    ListCampaign tile, {
    Key? key,
  })  : headerImage = tile.headerImage.url,
        title = tile.title,
        cause = tile.cause,
        campaign = tile,
        super(key: key);

  @override
  Widget buildBody(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.75,
      child: InkWell(
        onTap: () => context.router.push(
          CampaignInfoRoute(campaignId: campaign.id, listCampaign: campaign),
        ),
        child: Container(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 150),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    // FIXME ink animation doesn't cover image
                    CustomNetworkImage(
                      headerImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    BlocBuilder<UserProgressBloc, UserProgressState>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _ExploreTileCheckmark(
                            completed: state.campaignIsCompleted(campaign.id),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _ExploreTileTitle(title),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CauseIndicator(cause),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExploreActionTile extends ExploreResourceTile {
  final ListAction action;

  ExploreActionTile(
    ListAction tile, {
    ExploreTileStyle? style,
    Key? key,
  })  : action = tile,
        super(
          title: tile.title,
          type: tile.type.name,
          iconColor: tile.type.primaryColor,
          headerColor: tile.type.secondaryColor,
          dividerColor: tile.type.tertiaryColor,
          icon: tile.type.icon,
          cause: tile.cause,
          timeText: tile.timeText,
          getIsComplete: (state) => state.actionIsCompleted(tile.id),
          style: style,
          onTap: (BuildContext context) =>
              context.router.push(ActionInfoRoute(actionId: tile.id)),
          key: key,
        );
}

class ExploreLearningResourceTile extends StatelessWidget {
  final LearningResource tile;

  ExploreLearningResourceTile(this.tile);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExploreLearningResourceTileBloc(
        learningResource: tile,
        causesService: locator<CausesService>(),
      ),
      child: BlocListener<ExploreLearningResourceTileBloc,
          ExploreLearningResourceTileState>(
        listener: (context, state) {
          if (state is ExploreLearningResourceTileStateLaunching) {
            launchUrl(tile.link);
          }
        },
        child: BlocBuilder<ExploreLearningResourceTileBloc,
            ExploreLearningResourceTileState>(
          builder: (context, state) {
            return ExploreLearningResourceTileInner(
              tile,
              onTap: context
                  .read<ExploreLearningResourceTileBloc>()
                  .launchLearningResource,
            );
          },
        ),
      ),
    );
  }
}

class ExploreLearningResourceTileInner extends ExploreResourceTile {
  final LearningResource resource;

  ExploreLearningResourceTileInner(
    LearningResource tile, {
    required GestureTapCallback onTap,
    ExploreTileStyle? style,
    Key? key,
  })  : resource = tile,
        super(
          title: tile.title,
          type: tile.type.name,
          iconColor: blue0,
          headerColor: blue1,
          dividerColor: blue2,
          icon: tile.icon,
          cause: tile.cause,
          timeText: tile.timeText,
          key: key,
          style: style,
          onTap: (_) async => onTap(),
          getIsComplete: (state) => state.learningResourceIsCompleted(tile.id),
        );
}

abstract class ExploreResourceTile extends ExploreTile {
  final double COMPLETED_EXTENSION_WIDTH = 110;

  final String title;
  final String type;
  final Color iconColor;
  final Color headerColor;
  final Color dividerColor;
  final IconData icon;
  final Cause cause;
  final String timeText;
  final ExploreTileStyle style;
  final Future<void> Function(BuildContext context) onTap;
  final bool Function(UserProgressState state) getIsComplete;

  ExploreResourceTile({
    required this.title,
    required this.type,
    required this.iconColor,
    required this.headerColor,
    required this.dividerColor,
    required this.icon,
    required this.cause,
    required this.timeText,
    required this.onTap,
    required this.getIsComplete,
    ExploreTileStyle? style,
    Key? key,
  })  : this.style = style ?? ExploreTileStyle.Standard,
        super(key: key);

  @override
  Widget buildBody(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.65,
      child: InkWell(
        onTap: () => onTap(context),
        child: Column(
          children: [
            Flexible(
              child: Ink(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                color: headerColor,
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: iconColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      type,
                      textScaler: const TextScaler.linear(.8),
                    ),
                    VerticalDivider(
                      color: dividerColor,
                      indent: 12,
                      endIndent: 12,
                    ),
                    const FaIcon(
                      // Use FaIcon to center icons properly
                      FontAwesomeIcons.clock,
                      size: 16,
                      color: Color.fromRGBO(55, 58, 74, 1),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      timeText,
                      textScaler: const TextScaler.linear(.8),
                    ),
                    Expanded(child: Container()),
                    BlocBuilder<UserProgressBloc, UserProgressState>(
                      builder: (context, state) {
                        final isComplete = getIsComplete(state);
                        if (isComplete) {
                          return _ExploreTileCheckmark(
                            completed: isComplete,
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: style == ExploreTileStyle.Standard
                          ? _ExploreTileTitle(title)
                          : Padding(
                              padding: EdgeInsets.only(
                                right: COMPLETED_EXTENSION_WIDTH - 50,
                              ),
                              child: _ExploreTileTitle(title),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: CauseIndicator(cause),
                  ),
                ],
              ),
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class ExploreNewsArticleTile extends ExploreTile {
  final NewsArticle article;

  ExploreNewsArticleTile(
    NewsArticle tile, {
    Key? key,
  })  : article = tile,
        super(key: key);

  Widget buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => ExploreNewsArticleTileBloc(
        newsArticle: article,
        causesService: locator<CausesService>(),
      ),
      child:
          BlocListener<ExploreNewsArticleTileBloc, ExploreNewsArticleTileState>(
        listener: (context, state) async {
          if (state is ExploreNewsArticleTileLaunchingState) {
            await launchUrl(article.link);
            context.read<ExploreNewsArticleTileBloc>().markLaunched();
          }
        },
        child: BlocBuilder<ExploreNewsArticleTileBloc,
            ExploreNewsArticleTileState>(
          builder: (context, state) {
            return AspectRatio(
              aspectRatio: 0.8,
              child: InkWell(
                onTap: context
                    .read<ExploreNewsArticleTileBloc>()
                    .launchNewsArticle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxHeight: 150),
                      child: AspectRatio(
                        aspectRatio: 1.8,
                        // TODO ink animation doesn't cover image
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            CustomNetworkImage(
                              article.headerImage.url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 150,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BlocBuilder<UserProgressBloc,
                                  UserProgressState>(
                                builder: (context, state) {
                                  final isComplete =
                                      state.newsArticleIsCompleted(article.id);
                                  if (isComplete) {
                                    return _ExploreTileCheckmark(
                                      completed: isComplete,
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.title,
                              style:
                                  Theme.of(context).textTheme.headlineMedium!,
                              textScaler: const TextScaler.linear(.7),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              article.subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .apply(fontStyle: FontStyle.normal),
                            ),
                            Text(
                              article.publishedAt
                                  .let(DateFormat('d MMM y').format),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Ink(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(247, 248, 252, 1),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          article.shortUrl,
                          style: Theme.of(context).textTheme.bodyLarge?.apply(
                                color: const Color.fromRGBO(255, 136, 0, 1),
                              ),
                          textScaler: const TextScaler.linear(.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ExploreTileTitle extends StatelessWidget {
  final String title;

  const _ExploreTileTitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium!,
      textScaler: const TextScaler.linear(.6),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ExploreTileCheckmark extends StatelessWidget {
  /// If the card has been completed
  final bool completed;

  /// Colors for the checkmark
  static const Color _completedColor = Color.fromRGBO(89, 152, 26, 1);
  static const Color _uncompletedColor = Color.fromRGBO(155, 159, 177, 1);

  const _ExploreTileCheckmark({
    required this.completed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            margin: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
        FaIcon(
          FontAwesomeIcons.solidCircleCheck,
          color: completed ? _completedColor : _uncompletedColor,
        ),
      ],
    );
  }
}
