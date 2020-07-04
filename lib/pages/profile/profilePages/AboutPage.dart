import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:app/pages/profile/profilePages/FAQPage.dart';

import 'package:app/routes.dart';
import 'package:app/assets/StyleFrom.dart';
import 'package:app/assets/components/customAppBar.dart';
import 'package:app/assets/components/selectionItem.dart';
import 'package:app/assets/routes/customRoute.dart';

const double PADDING = 12;

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "About",
        context: context,
        backButtonText: "Menu",
      ),
      body: ListView(
       children: <Widget>[
         ListHeading("Give us feedback"),
         SelectionItem(
          text: "Rate us on App Store", 
          onClick: () {launch("www.google.com");},
         ),
         ListDividor(),
         SelectionItem(
          text: "Propose edits to now-u app", 
          onClick: () {launch("https://docs.google.com/forms/d/e/1FAIpQLSc6zL_9wVJZiZryJP2sIl2SMTtJFoi7fRCAJ1_Gn-rAmWygBQ/viewform");},
         ),
         ListDividor(),
         SelectionItem(
          text: "Propose a campaign",
          onClick: () {
            launch("https://docs.google.com/forms/d/1qv0DzXll02Szjh0SVmV-ysuYGQ2oPNS8-_qDZRYDbBA/edit");
          }
         ),
         
         ListHeading("Give us some love"),
         SelectionItem(
          text: "Like us on Facebook", 
          onClick: () {launch("https://www.facebook.com/nowufb");},
         ),
         ListDividor(),
         SelectionItem(
          text: "Follow us on Instagram", 
          onClick: () {launch("https://www.instagram.com/now_u_app/");},
         ),
         ListDividor(),
         SelectionItem(
          text: "Follow us on Twitter", 
          onClick: () {launch("https://twitter.com/now_u_app");},
         ),
         
         ListHeading("About"),
         SelectionItem(
          text: "FAQ", 
          onClick: () {
            Navigator.pushNamed(
              context, 
              Routes.faq,
            );
          },
         ),
         SelectionItem(
           text: "Send us a message", 
           onClick: () {launch("http://m.me/nowufb");},
         ),
         SelectionItem(
           text: "Send us an email", 
           onClick: () {launch("mailto:hello@now-u.com?subject=Hi there");},
         ),
       ], 
      ), 
    );
  }
}

class ListItem extends StatelessWidget {
  final String text;
  final Function onClick;
  ListItem(this.text, this.onClick);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Container(
          margin: EdgeInsets.all(0),
          child: SelectionItem(
            text: text,
            onClick: onClick,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          )
        ),
      )
    );
  }
}

class ListHeading extends StatelessWidget {
  final String text;
  ListHeading(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,       
      color: Theme.of(context).primaryColor,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.all(PADDING),
          child: Text(
            text,
            style: textStyleFrom(
              Theme.of(context).primaryTextTheme.headline5,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class ListDividor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, 
      height: 1,
      color: Color.fromRGBO(238,238,238,1),
    );
  }
}

