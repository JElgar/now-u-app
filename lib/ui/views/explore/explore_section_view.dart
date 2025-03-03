import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nowu/assets/components/card.dart';
import 'package:nowu/assets/constants.dart';
import 'package:nowu/router.gr.dart';
import 'package:nowu/themes.dart';
import 'package:nowu/ui/paging/paging_state.dart';
import 'package:nowu/ui/views/explore/explore_page_view.dart';

const double RESOURCE_TILE_HEIGHT = 160;
const double CAMPIGN_TILE_HEIGHT = 300;
const double ARTICLE_TILE_HEIGHT = 330;

class ExploreSectionWidget extends StatelessWidget {
  final String title;
  final GestureTapCallback? titleOnClick;
  final String? description;
  final double tileHeight;
  final PagingState<Widget> tileData;

  ExploreSectionWidget({
    required this.title,
    required this.titleOnClick,
    required this.description,
    required this.tileHeight,
    required this.tileData,
  });

  Widget _buildSectionHeader(
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          GestureDetector(
            onTap: titleOnClick,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.left,
                ),
                if (titleOnClick != null)
                  const Icon(Icons.chevron_right, size: 30),
              ],
            ),
          ),
          if (description != null)
            Text(
              description!,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.left,
            ),
        ],
      ),
    );
  }

  Widget _noTilesFound(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: BaseCard(
        Padding(
          padding: const EdgeInsets.all(CustomPaddingSize.normal),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Oops.. No items found',
                      style: regularTheme.textTheme.headlineMedium,
                    ),
                  ],
                ),
                const SizedBox(height: CustomPaddingSize.small),
                Text(
                  'Looks like we don’t have any ‘${title}’ to recommend right now. Check out our ‘Explore’ page to get involved another way.',
                  style: regularTheme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: CustomPaddingSize.small),
                FilledButton(
                  child: const Text('Explore'),
                  onPressed: () {
                    context.router.push(ExploreRoute());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTiles(BuildContext context) {
    final sectionHeight = tileHeight;

    switch (tileData) {
      case InitialLoading():
        {
          return Container(
            height: sectionHeight,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
      case Data(:final items):
        {
          if (items.length == 0) {
            return _noTilesFound(context);
          }

          return Container(
            height: sectionHeight,
            clipBehavior: Clip.none,
            child: ListView(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                const SizedBox(width: 8.0),
                ...items,
                const SizedBox(width: 8.0),
              ],
            ),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO When the input args changes, the viewmodel isn't updated
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Section header
            Column(
              children: [
                // Text header
                _buildSectionHeader(context),
                const SizedBox(height: 2),
                const SizedBox(height: CustomPaddingSize.small),
                _buildTiles(context),
                const SizedBox(height: CustomPaddingSize.normal),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
