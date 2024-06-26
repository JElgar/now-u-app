import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowu/assets/constants.dart';
import 'package:nowu/locator.dart';
import 'package:nowu/router.gr.dart';
import 'package:nowu/services/causes_service.dart';
import 'package:nowu/ui/views/explore/bloc/explore_filter_bloc.dart';
import 'package:nowu/ui/views/explore/bloc/explore_filter_state.dart';
import 'package:auto_route/auto_route.dart';

final double horizontalPadding = CustomPaddingSize.small;

@RoutePage()
class ExploreView extends StatelessWidget {
  final ExplorePageFilterData? filterData;

  ExploreView({Key? key, this.filterData}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocProvider(
      create: (context) => ExploreFilterBloc(
        causesService: locator<CausesService>(),
      ),
      child: ExploreTabs(),
    );
  }
}

class ExploreTabData {
  final String title;
  final PageRouteInfo route;

  const ExploreTabData({
    required this.title,
    required this.route,
  });
}

List<ExploreTabData> getTabs() {
  return [
    const ExploreTabData(
      title: 'All',
      route: const ExploreAllRoute(),
    ),
    const ExploreTabData(
      title: 'Actions',
      route: const ExploreActionRoute(),
    ),
    const ExploreTabData(
      title: 'Learn',
      route: const ExploreLearningResourceRoute(),
    ),
    const ExploreTabData(
      title: 'News',
      route: const ExploreNewsArticleRoute(),
    ),
  ];
}

class ExploreTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: getTabs().map((tab) => tab.route).toList(),
      builder: (conext, child, controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 1,
            shadowColor: CustomColors.greyLight1,
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 50,
              ),
              child: BlocBuilder<ExploreFilterBloc, ExploreFilterState>(
                builder: (context, state) {
                  return SearchBar(
                    leading: const Icon(Icons.search),
                    hintText: 'Explore now-u resources',
                    onChanged: (value) {
                      context
                          .read<ExploreFilterBloc>()
                          .updateFilter(state.copyWith(queryText: value));
                    },
                  );
                },
              ),
            ),
            // TODO Fix the routing here!
            bottom: TabBar(
              controller: controller,
              isScrollable: true,
              labelStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w400),
              tabs: getTabs().map((tab) => Text(tab.title)).toList(),
              tabAlignment: TabAlignment.start,
            ),
          ),
          body: child,
        );
      },
    );
  }
}
