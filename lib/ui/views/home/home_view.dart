import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowu/assets/components/customScrollableSheet.dart';
import 'package:nowu/assets/components/customTile.dart';
import 'package:nowu/assets/components/explore_tiles.dart';
import 'package:nowu/locator.dart';
import 'package:nowu/models/Notification.dart';
import 'package:nowu/models/exploreable.dart';
import 'package:nowu/router.gr.dart';
import 'package:nowu/services/causes_service.dart';
import 'package:nowu/services/search_service.dart';
import 'package:nowu/ui/common/cause_tile.dart';
import 'package:nowu/ui/components/user_progress/user_progress.dart';
import 'package:nowu/ui/paging/paging_state.dart';
import 'package:nowu/ui/views/authentication/bloc/authentication_bloc.dart';
import 'package:nowu/ui/views/authentication/bloc/authentication_state.dart';
import 'package:nowu/ui/views/causes/bloc/causes_bloc.dart';
import 'package:nowu/ui/views/causes/bloc/causes_state.dart';
import 'package:nowu/ui/views/explore/bloc/tabs/explore_action_tab_bloc.dart';
import 'package:nowu/ui/views/explore/bloc/tabs/explore_campaign_tab_bloc.dart';
import 'package:nowu/ui/views/explore/bloc/tabs/explore_news_article_tab_bloc.dart';
import 'package:nowu/ui/views/explore/bloc/tabs/explore_tab_bloc.dart';
import 'package:nowu/ui/views/explore/explore_section_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:nowu/ui/views/home/bloc/internal_notifications_bloc.dart';
import 'package:nowu/ui/views/home/bloc/internal_notifications_state.dart';

const double BUTTON_PADDING = 10;
const PageStorageKey campaignCarouselPageKey = PageStorageKey(1);

class ExploreSection<T extends Explorable> extends StatelessWidget {
  final double tileHeight;
  final ExploreSectionBloc<T, void> Function() buildBloc;
  final Widget Function(T item) buildTile;
  final String title;

  ExploreSection({
    required this.tileHeight,
    required this.buildBloc,
    required this.buildTile,
    required this.title,
  });

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => buildBloc()..search(null),
      child: BlocBuilder<ExploreSectionBloc<T, void>, ExploreTabState<T>>(
        builder: (context, state) {
          return ExploreSectionWidget(
            title: title,
            description: null,
            tileData: state.data.map((item) => buildTile(item as T)),
            titleOnClick: null,
            tileHeight: tileHeight,
          );
        },
      ),
    );
  }
}

@RoutePage()
class HomeView extends StatelessWidget {
  const HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.05),
      body: ScrollableSheetPage(
        header: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            String? getUserName() {
              switch (state) {
                case AuthenticationStateUnknown():
                case AuthenticationStateUnauthenticated():
                  return null;
                case AuthenticationStateAuthenticated(:final user):
                  return user.name;
              }
            }

            return BlocBuilder<InternalNotificationsBloc,
                InternalNotificationsState>(
              builder: (context, state) {
                switch (state) {
                  case InternalNotificationsStateLoading():
                  case InternalNotificationsStateError():
                  case InternalNotificationsStateLoaded(:final notifications)
                      when notifications.isEmpty:
                    return HeaderStyle1(name: getUserName());
                  case InternalNotificationsStateLoaded(:final notifications):
                    return HeaderWithNotifications(
                      name: getUserName(),
                      notification: notifications[0],
                      dismissNotification: () => context
                          .read<InternalNotificationsBloc>()
                          .dismissNotification(notifications[0].id!),
                      openNotification: () {
                        // TODO Navigate to internal notifications page
                      },
                    );
                }
              },
            );
          },
        ),
        children: [
          Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),

              ExploreSection(
                title: 'What can I do today?',
                buildBloc: () => HomeActionSectionBloc(
                  causesService: locator<CausesService>(),
                  searchService: locator<SearchService>(),
                ),
                buildTile: (item) => ExploreActionTile(item),
                tileHeight: RESOURCE_TILE_HEIGHT,
              ),
              ExploreSection(
                title: 'Campaigns of the month',
                buildBloc: () => HomeOfTheMonthCampaignSectionBloc(
                  causesService: locator<CausesService>(),
                  searchService: locator<SearchService>(),
                ),
                buildTile: (item) => ExploreCampaignTile(item),
                tileHeight: CAMPIGN_TILE_HEIGHT,
              ),
              FilledButton(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Explore'),
                ),
                onPressed: () {
                  context.router.push(ExploreRoute());
                },
              ),
              const SizedBox(height: 30),
              ProgressTile(),
              const SizedBox(height: 30),
              ExploreSection(
                title: 'Suggested campaigns',
                buildBloc: () => HomeRecommenedCampaignSectionBloc(
                  causesService: locator<CausesService>(),
                  searchService: locator<SearchService>(),
                ),
                buildTile: (item) => ExploreCampaignTile(item),
                tileHeight: CAMPIGN_TILE_HEIGHT,
              ),
              ExploreSection(
                title: 'In the news',
                buildBloc: () => HomeNewsArticleSectionBloc(
                  causesService: locator<CausesService>(),
                  searchService: locator<SearchService>(),
                ),
                buildTile: (item) => ExploreNewsArticleTile(item),
                tileHeight: ARTICLE_TILE_HEIGHT,
              ),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, authState) {
                  switch (authState) {
                    case AuthenticationStateUnauthenticated():
                    case AuthenticationStateUnknown():
                      return Container();
                    case AuthenticationStateAuthenticated():
                      {
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'My causes',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  TextButton(
                                    child: const Text('Edit'),
                                    onPressed: () {
                                      context.router.push(
                                        const ChangeSelectCausesRoute(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            BlocBuilder<CausesBloc, CausesState>(
                              builder: (context, state) {
                                switch (state) {
                                  case CausesStateLoading():
                                  // TODO Handle error
                                  case CausesStateError():
                                    return const CircularProgressIndicator();
                                  case CausesStateLoaded(:final causes):
                                    {
                                      return GridView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(20),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 20,
                                          crossAxisSpacing: 30,
                                        ),
                                        itemCount: causes.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return CauseTile(
                                            onSelect: () {
                                              context.router.push(
                                                const ChangeSelectCausesRoute(),
                                              );
                                            },
                                            cause: causes[index],
                                          );
                                        },
                                      );
                                    }
                                }
                              },
                            ),
                          ],
                        );
                      }
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class HeaderStyle1 extends StatelessWidget {
  final String? name;

  HeaderStyle1({this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.error,
            Theme.of(context).colorScheme.error,
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
              15,
              MediaQuery.of(context).size.height * 0.1,
              0,
              0,
            ),
            child: Text(
              name != null ? 'Welcome \n$name!' : 'Welcome!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    height: 0.95,
                  ),
            ),
          ),
          Positioned(
            right: -20,
            //top: actionsHomeTilePadding,
            bottom: MediaQuery.of(context).size.height * 0.05,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: const Image(
                image: AssetImage('assets/imgs/graphics/ilstr_home_1@3x.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderWithNotifications extends StatelessWidget {
  final String? name;
  final InternalNotification notification;
  final VoidCallback dismissNotification;
  final VoidCallback openNotification;

  HeaderWithNotifications({
    required this.name,
    required this.notification,
    required this.dismissNotification,
    required this.openNotification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * (1 - 0.4),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome back, $name',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          height: 0.95,
                        ),
                  ),
                  const SizedBox(height: 10),
                  NotificationTile(
                    notification,
                    dismissFunction: dismissNotification,
                    openNotification: openNotification,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final InternalNotification notification;
  final Function dismissFunction;
  final VoidCallback openNotification;

  NotificationTile(
    this.notification, {
    required this.dismissFunction,
    required this.openNotification,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTile(
      onClick: openNotification,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.notifications_active,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: 2),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 10),
                Text(
                  notification.getTitle()!,
                  style: Theme.of(context).textTheme.displayMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  notification.getSubtitle() ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ),

          // Dismiss button
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              child: MaterialButton(
                onPressed: () {
                  dismissFunction(notification.getId());
                },
                elevation: 2.0,
                minWidth: 0,
                color: const Color.fromRGBO(196, 196, 196, 1),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(0),
                shape: const CircleBorder(),
                height: 10,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
