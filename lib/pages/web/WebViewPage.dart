import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wanandroid/fonts/IconF.dart';
import 'package:wanandroid/model/article_list/ArticleItemModel.dart';
import 'package:wanandroid/utils/CollectUtil.dart';
import 'package:wanandroid/widget/BackBtn.dart';

class WebViewPage extends StatefulWidget {
  final String? url;
  final String? title;
  final ArticleItemModel? articleBean;

  WebViewPage({this.url, this.title, this.articleBean});

  @override
  State<StatefulWidget> createState() => new _WebViewState();

  String getUrl() {
    return url ?? articleBean?.link ?? "";
  }

  String getTitle() {
//    return ""; //在标题栏不展示文章title，更加简介
    return title ?? articleBean?.title ?? "";
  }
}

class _WebViewState extends State<WebViewPage> {
  String? toastMsg;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
// //      scrollBar: true,
// //      withZoom: true,
// //      withLocalStorage: true,
// //      withLocalUrl: true,
//       url: widget.getUrl(),
//       appBar: AppBar(
//         title: Text(
//           toastMsg ?? widget.getTitle(),
//           textAlign: null != toastMsg ? TextAlign.center : TextAlign.start,
//           style: null != toastMsg
//               ? TextStyle(
//                   fontSize: 15.0,
//                   color: Colors.yellow,
//                 )
//               : null,
//         ),
//         leading: BackBtn(),
//         actions: <Widget>[
//           _buildStared(context),
//           _buildOpenWithBrowser(),
//         ],
//       ),
//     );
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text(
          toastMsg ?? widget.getTitle(),
          textAlign: null != toastMsg ? TextAlign.center : TextAlign.start,
          style: null != toastMsg
              ? TextStyle(
                  fontSize: 15.0,
                  color: Colors.yellow,
                )
              : null,
        ),
        leading: BackBtn(),
        actions: <Widget>[
          _buildStared(context),
          _buildOpenWithBrowser(),
        ],
      ),
        // body: WebViewWidget(controller: _controller),
      // floatingActionButton: favoriteButton(),
    );
  }

  Widget _buildStared(BuildContext context) {
    if (null == widget.articleBean || null == widget.articleBean?.collect) {
      return Text("");
    } else
      return IconButton(
        icon: Icon(
          (widget.articleBean?.collect ?? false)
              ? IconF.like_fill
              : IconF.like_stroke,
          color: Colors.white,
        ),
        onPressed: () {
          CollectUtil.updateCollectState(context, widget.articleBean!,
              (bool isOK, String errorMsg) {
            if (isOK) {
              setState(() {
                widget.articleBean!.collect = !widget.articleBean!.collect;
              });
            } else {
              setState(() {
                toastMsg = errorMsg;
              });
              Timer(Duration(seconds: 2), () {
                setState(() {
                  toastMsg = null;
                });
              });
            }
          });
        },
      );
  }

  Widget _buildOpenWithBrowser() {
    return IconButton(
      icon: Icon(IconF.browser),
      onPressed: () {
        launch(widget.getUrl());
      },
    );
  }
}
