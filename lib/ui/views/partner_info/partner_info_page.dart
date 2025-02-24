import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nowu/assets/components/custom_network_image.dart';
import 'package:nowu/assets/components/sectionTitle.dart';
import 'package:auto_route/auto_route.dart';
import 'package:nowu/models/organisation.dart';
import 'package:nowu/router.dart';
import 'package:nowu/router.gr.dart';

final double SECTION_TITLE_BOTTOM_PADDING = 8;
final double BETWEEN_SECTION_PADDING = 12;

// TODO Take in organisationId as path param
@RoutePage()
class PartnerInfoView extends StatelessWidget {
  final Organisation organisation;
  const PartnerInfoView({Key? key, required this.organisation})
      : super(key: key);

  Iterable<Widget> getSocialMediaChildren(Organisation org) {
    final List<({Uri? link, IconData icon})> socialButtons = [
      (link: org.instagramLink, icon: FontAwesomeIcons.instagram),
      (link: org.facebookLink, icon: FontAwesomeIcons.facebookF),
      (link: org.twitterLink, icon: FontAwesomeIcons.twitter),
      (link: org.mailToLink, icon: FontAwesomeIcons.envelope),
      (link: org.websiteLink, icon: Icons.language),
    ];
    return socialButtons
        .where((button) => button.link != null)
        .map(
          (button) => SocialMediaButton(
            icon: button.icon,
            url: button.link!,
          ),
        )
        .toList();
  }

  Iterable<Widget> getExtraLinks(Organisation org) {
    return org.extraLinks.map(
      (link) => ExtraLinkButton(
        title: link.title,
        url: link.link,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Body
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: <Widget>[
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () => context.router.push(const MoreRoute()),
                        label: const Text('More'),
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Text(
                        organisation.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 120,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: CustomNetworkImage(organisation.logo.url),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SectionTitle(
                  'About',
                  vpadding: SECTION_TITLE_BOTTOM_PADDING,
                ),
                Text(
                  organisation.description,
                ),
                SizedBox(height: BETWEEN_SECTION_PADDING),
                organisation.geographicReach == null
                    ? Container()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionTitle(
                            'Geographic reach',
                            vpadding: SECTION_TITLE_BOTTOM_PADDING,
                          ),
                          Text(
                            organisation.geographicReach!,
                          ),
                        ],
                      ),
                SizedBox(height: BETWEEN_SECTION_PADDING),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(
                      'Organisation type',
                      vpadding: SECTION_TITLE_BOTTOM_PADDING,
                    ),
                    Text(
                      organisation.organisationTypeMeta.name,
                    ),
                  ],
                ),
                SizedBox(height: BETWEEN_SECTION_PADDING),
                getSocialMediaChildren(organisation).length == 0
                    ? Container()
                    : SectionTitle(
                        'Follow this partner on social media',
                        vpadding: SECTION_TITLE_BOTTOM_PADDING,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: getSocialMediaChildren(organisation).toList(),
                ),
                getSocialMediaChildren(organisation).length == 0
                    ? Container()
                    : SizedBox(height: BETWEEN_SECTION_PADDING),
                getExtraLinks(organisation).length == 0
                    ? Container()
                    : SectionTitle(
                        'Find out more',
                      ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: getExtraLinks(organisation).toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SocialMediaButton extends StatelessWidget {
  final IconData icon;
  final Uri url;

  const SocialMediaButton({
    required this.icon,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(
          icon,
          color: const Color.fromRGBO(155, 159, 177, 1),
          size: 35,
        ),
        onPressed: () => launchLinkExternal(context, url),
      ),
    );
  }
}

class ExtraLinkButton extends StatelessWidget {
  final String title;
  final Uri url;

  const ExtraLinkButton({
    required this.title,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () => launchLinkExternal(context, url),
        child: new Text(title),
      ),
    );
  }
}
