import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:wanandroid/api/Api.dart';
import 'package:wanandroid/api/CommonService.dart';
import 'package:wanandroid/common/GlobalConfig.dart';
import 'package:wanandroid/model/knowledge_systems/KnowledgeSystemsChildModel.dart';
import 'package:wanandroid/model/knowledge_systems/KnowledgeSystemsModel.dart';
import 'package:wanandroid/model/knowledge_systems/KnowledgeSystemsParentModel.dart';
import 'package:wanandroid/pages/article_list/ArticleListPage.dart';

class KnowledgeSystemsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _KnowledgeSystemsPageState();
  }
}

class _KnowledgeSystemsPageState extends State<KnowledgeSystemsPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  double _screenWidth = MediaQueryData.fromView(ui.window).size.width;
  late KnowledgeSystemsModel _treeModel;
  late TabController _tabControllerOutter;
  Map<int, TabController> _tabControllerInnerMaps = Map();
  late KnowledgeSystemsParentModel _currentTreeRootModel;

  var loading = true;

  @override
  void initState() {
    super.initState();
    _loadTreeList();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loading) {
      return Center(
        child: Text("loading..."),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          GlobalConfig.knowledgeSystemsTab,
          style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
        ),
        centerTitle: true,
        bottom: _buildTitleBottom(),
      ),
      body: _buildBody(_currentTreeRootModel),
    );
  }

  PreferredSize? _appBarBottom;

  PreferredSize _buildTitleBottom() {
    if (null == _appBarBottom)
      _appBarBottom = PreferredSize(
        child: _buildTitleTabs(),
        preferredSize: Size(_screenWidth, kToolbarHeight * 2),
      );
    return _appBarBottom!;
  }

  Widget _buildTitleTabs() {
    _tabControllerOutter =
        TabController(length: _treeModel.data.length ?? 0, vsync: this);
    _tabControllerOutter.addListener(() {
      setState(() {
        _currentTreeRootModel = _treeModel.data[_tabControllerOutter.index];
      });
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          child: TabBar(
            controller: _tabControllerOutter,
            labelColor: Colors.grey[700],
            isScrollable: true,
            unselectedLabelColor: Colors.grey[400],
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.only(bottom: 2.0),
            indicatorWeight: 1.0,
            indicatorColor: Colors.grey[700],
            tabs: _buildRootTabs(),
          ),
          width: _screenWidth,
          height: kToolbarHeight,
        ),
        SizedBox(
          child: TabBarView(
            children: _buildSecondTitle(),
            controller: _tabControllerOutter,
          ),
          width: _screenWidth,
          height: kToolbarHeight,
        ),
      ],
    );
  }

  List<Widget> _buildRootTabs() {
    return _treeModel.data.map((KnowledgeSystemsParentModel model) {
          return Tab(
            text: model.name,
          );
        }).toList() ??
        [];
  }

  List<Widget> _buildSecondTitle() {
    return _treeModel.data.map(_buildSingleSecondTitle).toList() ?? [];
  }

  Widget _buildSingleSecondTitle(KnowledgeSystemsParentModel model) {
    if (null == _tabControllerInnerMaps[model.id])
      _tabControllerInnerMaps[model.id] =
          TabController(length: model.children.length, vsync: this);
    return TabBar(
      controller: _tabControllerInnerMaps[model.id],
      labelColor: Colors.grey[700],
      isScrollable: true,
      unselectedLabelColor: Colors.grey[400],
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.only(bottom: 2.0),
      indicatorWeight: 1.0,
      indicatorColor: Colors.grey[700],
      tabs: _buildSecondTabs(model),
    );
  }

  List<Widget> _buildSecondTabs(KnowledgeSystemsParentModel model) {
    return model.children.map((KnowledgeSystemsChildModel model) {
      return Tab(
        text: model.name,
      );
    }).toList();
  }

  Widget _buildBody(KnowledgeSystemsParentModel model) {
    if (null == _tabControllerInnerMaps[model.id])
      _tabControllerInnerMaps[model.id] =
          TabController(length: model.children.length, vsync: this);
    return TabBarView(
      key: Key("tb${model.id}"),
      children: _buildPages(model),
      controller: _tabControllerInnerMaps[model.id],
    );
  }

  List<Widget> _buildPages(KnowledgeSystemsParentModel model) {
    return model.children.map(_buildSinglePage).toList() ?? [];
  }

  Widget _buildSinglePage(KnowledgeSystemsChildModel model) {
    return ArticleListPage(
      key: Key("${model.id}"),
      request: (page) {
        return CommonService().getTreeItemList(
            "${Api.TREES_DETAIL_LIST}$page/json?cid=${model.id}");
      },
    );
  }

  void _loadTreeList() async {
    CommonService().getTrees((KnowledgeSystemsModel _bean) {
      if (mounted) {
        setState(() {
          loading = false;
          _treeModel = _bean;
          _currentTreeRootModel = _treeModel.data[0];
        });
      }
    });
  }

  @override
  void dispose() {
    // _tabControllerOutter.dispose();
    _tabControllerInnerMaps.forEach((_, controller) {
      controller.dispose();
    });
    super.dispose();
  }
}
