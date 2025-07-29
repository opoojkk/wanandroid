import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wanandroid/api/CommonService.dart';
import 'package:wanandroid/common/Sp.dart';
import 'package:wanandroid/model/login/UserModel.dart';
import 'package:wanandroid/utils/DateUtil.dart';

class User {
  String? userName;
  String? password;
  String? cookie;
  late DateTime cookieExpiresTime;
  Map<String, String>? _headerMap;

  static final User _singleton = User._internal();

  factory User() {
    return _singleton;
  }

  User._internal();

  bool isLogin() {
    return (userName?.length ?? 0) >= 6 && (password?.length ?? 0) >= 6;
  }

  void logout() {
    Sp.putUserName("");
    Sp.putPassword("");
    userName = null;
    password = null;
    _headerMap = null;
  }

  void refreshUserData({Function? callback}) {
    Sp.getPassword((pw) {
      this.password = pw;
    });
    Sp.getUserName((str) {
      this.userName = str;
      callback?.call();
    });
    Sp.getCookie((str) {
      this.cookie = str;
      _headerMap = null;
    });
    Sp.getCookieExpires((str) {
      if (null != str && str.length > 0) {
        this.cookieExpiresTime = DateTime.parse(str);
        //提前3天请求新的cookie
        if (cookieExpiresTime.isAfter(DateUtil.getDaysAgo(3))) {
          Timer(Duration(milliseconds: 100), () {
            autoLogin();
          });
        }
      }
    });
  }

  void login({Function? callback}) {
    _saveUserInfo(CommonService().login(userName, password), userName ?? "",
        password ?? "",
        callback: callback);
  }

  void register({Function? callback}) {
    _saveUserInfo(CommonService().register(userName, password), userName ?? "",
        password ?? "",
        callback: callback);
  }

  void _saveUserInfo(
      Future<Response> responseF, String userName, String password,
      {Function? callback}) {
    responseF.then((response) {
      var userModel = UserModel.fromJson(response.data);
      if (userModel.errorCode == 0) {
        Sp.putUserName(userName);
        Sp.putPassword(password);
        String cookie = "";
        DateTime expires = DateTime.now();
        response.headers.forEach((String name, List<String> values) {
          if (name == "set-cookie") {
            cookie = json
                .encode(values)
                .replaceAll("\[\"", "")
                .replaceAll("\"\]", "")
                .replaceAll("\",\"", "; ");
            try {
              expires = DateUtil.formatExpiresTime(cookie) ?? DateTime.now();
            } catch (e) {}
          }
        });
        Sp.putCookie(cookie);
        Sp.putCookieExpires(expires.toIso8601String());
        callback?.call(true, null);
      } else {
        callback?.call(false, userModel.errorMsg);
      }
    });
  }

  void autoLogin() {
    if (isLogin()) {
      login();
    }
  }

  Map<String, String> getHeader() {
    return _headerMap ?? Map();
  }
}
