import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nowu/assets/components/customScrollableSheet.dart';
import 'package:nowu/assets/components/customTile.dart';
import 'package:nowu/locator.dart';
import 'package:nowu/models/faq.dart';
import 'package:nowu/router.gr.dart';
import 'package:nowu/services/faq_service.dart';
import 'package:nowu/ui/views/faq/bloc/faq_bloc.dart';
import 'package:nowu/ui/views/faq/bloc/faq_state.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_route/auto_route.dart';

// TODO There is a bug on this page when you tap the last FAQ the answer is not visible without scrolling
// Maybe need something like: https://stackoverflow.com/questions/49153087/flutter-scrolling-to-a-widget-in-listview
@RoutePage()
class FaqView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FaqBloc(faqService: locator<FAQService>())..getFaqs(),
      child: Scaffold(
        body: ScrollableSheetPage(
          initialChildSize: 0.85,
          minChildSize: 0.85,
          shadow: const BoxShadow(
            color: Colors.transparent,
          ),
          scaffoldBackgroundColor: const Color.fromRGBO(247, 248, 252, 1),
          sheetBackgroundColor: Colors.white,
          header: Container(
            height: MediaQuery.of(context).size.height * (1 - 0.6),
            width: double.infinity,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/imgs/graphics/ilstr_FAQ.png',
                    height: MediaQuery.of(context).size.height * 0.3,
                    alignment: Alignment.topRight,
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      TextButton.icon(
                        onPressed: () => context.router.push(const MoreRoute()),
                        label: const Text('More'),
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Text(
                        'FAQs',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          children: [
            BlocBuilder<FaqBloc, FaqState>(
              builder: (context, state) {
                switch (state) {
                  case FaqStateInitial():
                    return const Center(child: CircularProgressIndicator());
                  case FaqStateSuccess(:final faqs):
                    return Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: faqs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FaqTile(faqs[index]);
                        },
                      ),
                    );
                  case FaqStateFailure():
                    // TODO Better handling? Maybe retry button??
                    return const Text('Something went wrong!');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FaqTile extends StatefulWidget {
  final Faq faq;
  FaqTile(this.faq);
  @override
  _FaqTileState createState() => _FaqTileState();
}

class _FaqTileState extends State<FaqTile> {
  late bool selected;
  @override
  void initState() {
    selected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              CustomTile(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.faq.question,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
                      const Icon(
                        FontAwesomeIcons.chevronDown,
                        color: Color.fromRGBO(109, 113, 129, 1),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              selected
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      child: Text(
                        widget.faq.answer,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
