import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowu/assets/components/cause_indicator.dart';
import 'package:nowu/assets/components/custom_network_image.dart';
import 'package:nowu/assets/components/explore_tiles.dart';
import 'package:nowu/assets/constants.dart';
import 'package:flutter/material.dart';
import 'package:nowu/locator.dart';
import 'package:nowu/router.gr.dart';
import 'package:nowu/services/causes_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:nowu/ui/components/user_progress/bloc/user_progress_bloc.dart';
import 'package:nowu/ui/components/user_progress/bloc/user_progress_state.dart';
import 'package:nowu/ui/views/campaign_info/bloc/campaign_info_bloc.dart';
import 'package:nowu/ui/views/campaign_info/bloc/campaign_info_state.dart';
import 'package:tuple/tuple.dart';

@RoutePage()
class CampaignInfoView extends StatelessWidget {
  final int campaignId;
  final ListCampaign? listCampaign;

  CampaignInfoView({
    @pathParam required this.campaignId,
    this.listCampaign,
  });

  // TODO share this with the explore page header
  Widget _title(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CustomPaddingSize.small,
          vertical: 20,
        ),
        child: GestureDetector(
          onTap: () async {
            final didPop = await context.router.maybePop();
            if (!didPop) {
              await context.router.navigate(
                TabsRoute(children: [const HomeRoute()]),
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.chevron_left, size: 30),
              Text(
                'Campaign',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heading(BuildContext context, ListCampaign? campaign) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        if (campaign != null)
          CustomNetworkImage(
            campaign.headerImage.url,
            height: 193,
            width: double.infinity,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
          )
        else
          const Center(child: const CircularProgressIndicator()),
        Padding(
          padding: const EdgeInsets.all(CustomPaddingSize.normal),
          child: Text(
            campaign?.title ?? 'Loading...',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _causeIndicator(Cause? cause) {
    return Container(
      color: CustomColors.greyLight1,
      height: 43,
      child: cause != null
          ? CauseIndicator(
              cause,
            )
          : Container(),
    );
  }

  List<Widget> _resourcesList(
    BuildContext context,
    CampaignInfoState state,
  ) {
    switch (state) {
      case CampaignInfoStateInitial():
        return [
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ];
      case CampaignInfoStateSuccess(:final campaign):
        List<Tuple2<Widget, bool>> campaignResourceTiles = [];
        campaignResourceTiles.addAll(
          campaign.actions.map(
            (action) => Tuple2(
              ExploreActionTile(action),
              context
                  .read<UserProgressBloc>()
                  .state
                  .actionIsCompleted(action.id),
            ),
          ),
        );
        campaignResourceTiles.addAll(
          campaign.learningResources.map(
            (learningResource) => Tuple2(
              ExploreLearningResourceTile(learningResource),
              context
                  .read<UserProgressBloc>()
                  .state
                  .learningResourceIsCompleted(learningResource.id),
            ),
          ),
        );

        // Shuffle and then place completed at the end of the list
        campaignResourceTiles.shuffle();
        campaignResourceTiles.sort((a, b) => a.item2 == true ? -1 : 1);

        return campaignResourceTiles
            .map((tile) => tile.item1)
            .map(
              (resource) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  height: 160,
                  width: double.infinity,
                  child: resource,
                ),
              ),
            )
            .toList();

      case CampaignInfoStateFailure():
        return [
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text('An error occurred'),
            ),
          ),
        ];
    }
  }

  String getCampaignDescription(CampaignInfoState state) {
    switch (state) {
      case CampaignInfoStateInitial():
      case CampaignInfoStateFailure():
        return '';
      case CampaignInfoStateSuccess(:final campaign):
        return campaign.description;
    }
  }

  Widget _body(BuildContext context, CampaignInfoState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CustomPaddingSize.small,
        vertical: CustomPaddingSize.normal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
              Text(
                'About this campaign',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontSize: 18),
              ),
              Text(
                getCampaignDescription(state),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: CustomPaddingSize.normal),
              Text(
                'Support this campaign by completing these actions',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontSize: 18),
              ),
            ] +
            _resourcesList(context, state),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => CampaignInfoBloc(causesService: locator<CausesService>())
          ..fetchCampaign(campaignId),
        child: BlocBuilder<CampaignInfoBloc, CampaignInfoState>(
          builder: (context, state) {
            ListCampaign? getCampaignInfo() {
              switch (state) {
                case CampaignInfoStateSuccess(:final campaign):
                  return campaign;
                default:
                  return listCampaign;
              }
            }

            final campaignInfo = getCampaignInfo();

            return ListView(
              children: [
                _title(context),
                _heading(context, campaignInfo),
                _causeIndicator(campaignInfo?.cause),
                _body(context, state),
              ],
            );
          },
        ),
      ),
    );
  }
}
