import 'package:flutter/material.dart';
import 'package:wanandroid/common/GlobalConfig.dart';
import 'package:wanandroid/common/User.dart';
import 'package:wanandroid/fonts/IconF.dart';
import 'package:wanandroid/pages/home/HomePage.dart';
import 'package:wanandroid/pages/knowledge_systems/KnowledgeSystemsPage.dart';
import 'package:wanandroid/pages/mine/MinePage.dart';

class ApplicationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ApplicationPageState();
  }
}

class _ApplicationPageState extends State<ApplicationPage>
    with SingleTickerProviderStateMixin {
  int currentPageIndex = 0;
  late PageController _pageController;

  final List<BottomNavigationBarItem> _bottomTabs = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(IconF.blog),
        label: GlobalConfig.homeTab,
        backgroundColor: GlobalConfig.colorPrimary),
    BottomNavigationBarItem(
        icon: Icon(IconF.project),
        label: GlobalConfig.projectTab,
        backgroundColor: GlobalConfig.colorPrimary),
    BottomNavigationBarItem(
        icon: Icon(IconF.wechat),
        label: GlobalConfig.weChatTab,
        backgroundColor: GlobalConfig.colorPrimary),
    BottomNavigationBarItem(
        icon: Icon(IconF.tree),
        label: GlobalConfig.knowledgeSystemsTab,
        backgroundColor: GlobalConfig.colorPrimary),
    BottomNavigationBarItem(
        icon: Icon(IconF.me),
        label: GlobalConfig.mineTab,
        backgroundColor: GlobalConfig.colorPrimary),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: this.currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User().refreshUserData();
    return Scaffold(
      key: ValueKey('application'),
      body: IndexedStack(
        children: <Widget>[
          HomePage(),
          KnowledgeSystemsPage(),
          MinePage()
        ],
        index: currentPageIndex,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.article),
            icon: Icon(Icons.article_outlined),
            label: 'Articles',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.book),
            icon: Icon(Icons.book_outlined),
            label: '体系',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person_2),
            icon: Icon(Icons.person_2_outlined),
            label: '我',
          ),
        ],
      ),
    );
  }

  void onTap(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int index) {
    setState(() {
      this.currentPageIndex = index;
    });
  }
}
