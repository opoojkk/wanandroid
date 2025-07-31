import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:wanandroid/api/CommonService.dart';
import 'package:wanandroid/common/GlobalConfig.dart';
import 'package:wanandroid/common/Router.dart';
import 'package:wanandroid/fonts/IconF.dart';
import 'package:wanandroid/model/homebanner/HomeBannerItemModel.dart';
import 'package:wanandroid/model/homebanner/HomeBannerModel.dart';
import 'package:wanandroid/pages/article_list/ArticleListPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late List<HomeBannerItemModel> _bannerData;
  var _loading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadBannerData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(GlobalConfig.homeTab),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(IconF.search),
            onPressed: () {
              Router().openSearch(context);
            },
          )
        ],
      ),
      body: ArticleListPage(
        header: _buildBanner(context),
        request: (page) {
          return CommonService().getArticleListData(page);
        },
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    if (_loading) {
      return Center();
      return Center(
        child: Text("Loading"),
      );
    } else {
      double screenWidth = MediaQueryData.fromView(ui.window).size.width;
      return Container(
        height: screenWidth * 500 / 900,
        width: screenWidth,
        child: Swiper(
          itemHeight: screenWidth * 500 / 900,
          itemWidth: screenWidth,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                HomeBannerItemModel item = _bannerData[index];
                Router().openWeb(context, item.url, item.title);
              },
              child: CachedNetworkImage(
                fadeInDuration: Duration(milliseconds: 0),
                fadeOutDuration: Duration(milliseconds: 0),
                imageUrl: _bannerData[index].imagePath,
                fit: BoxFit.fill,
              ),
            );
          },
          itemCount: _bannerData.length,
          pagination: SwiperPagination(),
          autoplay: true,
        ),
      );
    }
  }

  void _loadBannerData() {
    CommonService().getBanner((HomeBannerModel _bean) {
      // 暂时这么写，状态管理不完善
      _loading = false;
      if (_bean.data.length > 0) {
        setState(() {
          _bannerData = _bean.data;
        });
      }
    });
  }
}
