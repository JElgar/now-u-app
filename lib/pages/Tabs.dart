import 'package:app/pages/learning/LearningCentreAllPage.dart';
import 'package:flutter/material.dart';

import 'package:app/assets/icons/customIcons.dart';

import 'package:app/pages/home/Home.dart';
import 'package:app/pages/more/MoreMenu.dart';
import 'package:app/pages/news/NewsPage.dart';
import 'package:app/pages/action/ActionPage.dart';
import 'package:app/pages/explore/ExplorePage.dart';

//import 'package:app/assets/dynamicLinks.dart';

// These must be in the corect order
enum TabPage { Home, Actions, Learning, News, Menu }

class TabsPage extends StatefulWidget {
  final TabPage currentPage;
  final dynamic arguments;

  TabsPage({this.currentPage, this.arguments});

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> with WidgetsBindingObserver {
  TabPage currentPage;

  @override
  void initState() {
    currentPage = widget.currentPage;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void changePage(TabPage page, {int subIndex}) {
    print("Changing page");
    print(page);
    print(subIndex);
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO add an enum so pages numbers can change
    List<Map> _pages = <Map>[
      {
        'page': Home(changePage),
        'icon': Icon(CustomIcons.ic_home),
        'title': "Home",
      },
      {
        'page': ActionPage(),
        'icon': Icon(CustomIcons.ic_actions),
        'title': "Actions",
      },
      {
        'page': LearningCentreAllPage(),
        'icon': Icon(CustomIcons.ic_learning),
        'title': "Learning",
      },
      {
        'page': NewsPage(),
        'icon': Icon(CustomIcons.ic_news),
        'title': "News",
      },
      {
        'page': campaign_explore_page,
        'icon': Icon(CustomIcons.ic_news),
        'title': "Explore",
      },
      {
        'page': Profile(),
        'icon': Icon(CustomIcons.ic_more),
        'title': "More",
      },
    ];
    List<BottomNavigationBarItem> generateBottomNavBarItems() {
      List<BottomNavigationBarItem> items = [];
      for (int i = 0; i < _pages.length; i++) {
        items.add(new BottomNavigationBarItem(
            activeIcon: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: <Color>[
                      Theme.of(context).errorColor,
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor,
                    ]).createShader(bounds);
              },
              child: _pages[i]['icon'],
            ),
            icon: _pages[i]['icon'],
            label: _pages[i]['title']));
      }
      return items;
    }

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: _pages[currentPage.index]['page'],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentPage.index,
            type: BottomNavigationBarType.fixed,
            elevation: 3,
            iconSize: 25,
            unselectedLabelStyle: TextStyle(
                color: Color.fromRGBO(155, 159, 177, 1), fontSize: 10),
            selectedLabelStyle: TextStyle(color: Colors.red, fontSize: 12),
            unselectedItemColor: Color.fromRGBO(155, 159, 177, 1),
            items: generateBottomNavBarItems(),
            onTap: (index) {
              setState(() {
                currentPage = TabPage.values[index];
              });
            },
          ),
        ));
  }
}
