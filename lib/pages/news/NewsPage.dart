import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/assets/StyleFrom.dart';
import 'package:app/assets/components/header.dart';
import 'package:app/assets/components/selectionPill.dart';
import 'package:app/assets/components/custom_network_image.dart';

import 'package:app/models/Article.dart';

import 'package:stacked/stacked.dart';
import 'package:app/viewmodels/news_model.dart';

final double pagePadding = 15;
final Color headerColor = Color.fromRGBO(247, 248, 252, 1);

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: EdgeInsets.all(0),
            // TODO do a test of a list of all articles
            child: ViewModelBuilder<NewsViewModel>.reactive(
                viewModelBuilder: () => NewsViewModel(),
                onModelReady: (model) => model.fetchArticles(),
                builder: (context, model, child) {
                  return ListView(children: <Widget>[
                    Container(
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            color: colorFrom(
                              Colors.black,
                              opacity: 0.08,
                            ),
                            offset: Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ]),
                        child: PageHeader(
                          title: "News",
                        )),
                    Container(
                        //color: Color.fromRGBO(247, 248, 252, 1),
                        color: headerColor,
                        child: Column(
                          children: <Widget>[
                            Container(
                                decoration: BoxDecoration(
                                    color: colorFrom(
                                      Colors.white,
                                      opacity: 0.6,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorFrom(
                                          Colors.black,
                                          opacity: 0.08,
                                        ),
                                        offset: Offset(0, 1),
                                        blurRadius: 3,
                                      )
                                    ]),
                                height: 60,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: model.campaigns.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                          padding: EdgeInsets.all(5),
                                          child: GestureDetector(
                                              onTap: () {
                                                model.onTapPill(index);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: SelectionPill(
                                                  "#" +
                                                      model.campaigns[index]
                                                          .getShortName(),
                                                  model.pillIsSelected(index),
                                                  fontSize: 12,
                                                  borderRadius: 25,
                                                ),
                                              )));
                                    })),

                            SizedBox(
                              height: pagePadding,
                            ),

                            SizedBox(height: 10),

                            // News aritcles
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: model.filteredArticles.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                    padding: EdgeInsets.only(
                                      left: pagePadding,
                                      right: pagePadding,
                                      bottom: 10,
                                    ),
                                    child: NewsTile(
                                      article: model.filteredArticles[index],
                                      model: model,
                                    ));
                              },
                            ),
                            SizedBox(width: 20),
                          ],
                        ))
                  ]);
                })));
  }
}

class NewsTile extends StatelessWidget {
  final Article article;
  final double height = 80;
  final NewsViewModel model;

  NewsTile({@required this.article, this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          model.openArticle(article);
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                    color: colorFrom(
                      Colors.black,
                      opacity: 0.08,
                    ),
                    offset: Offset(0, 15),
                    blurRadius: 25)
              ]),
          child: Column(
            children: [
              Container(
                  height: 160,
                  width: double.infinity,
                  child: CustomNetworkImage(
                    article.getHeaderImage(),
                    fit: BoxFit.cover,
                  )),

              // Titile
              Padding(
                padding: EdgeInsets.all(12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.getTitle() ?? "",
                        style: textStyleFrom(
                          Theme.of(context).primaryTextTheme.headline3,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 0.97,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        article.getSubtitle() ?? "",
                        style: textStyleFrom(
                            Theme.of(context).primaryTextTheme.headline5,
                            color: Color.fromRGBO(109, 113, 129, 1)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      article.getReleaseDate() == null
                          ? Container()
                          : Text(
                              DateFormat('d MMMM yyyy')
                                  .format(article.getReleaseDate()),
                              style: textStyleFrom(
                                Theme.of(context).primaryTextTheme.bodyText1,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              // Source
              article.getSource() == null
                  ? Container()
                  : Container(
                      color: Color.fromRGBO(247, 248, 252, 1),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            article.getSource(),
                            style: textStyleFrom(
                              Theme.of(context).primaryTextTheme.bodyText1,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ));
  }
}
