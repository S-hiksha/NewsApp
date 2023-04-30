import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internapp/model/article.dart';
import 'package:internapp/model/newsmodel.dart';
import 'package:http/http.dart' as http;

class NewsController extends GetxController {
  List<ArticleModel> news = <ArticleModel>[];
  ScrollController scrollController = ScrollController();
  RxBool notFound = false.obs;
  RxBool isLoading = false.obs;
  RxString cName = ''.obs;
  RxString country = ''.obs;
  RxString findNews = ''.obs;
  RxInt pageNum = 1.obs;
  dynamic isSwitched = false.obs;
  dynamic isPageLoading = false.obs;
  RxInt pageSize = 10.obs;
  String baseApi = "https://newsapi.org/v2/top-headlines?";

  @override
  void onInit() {
    ScrollController scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    getNews();
    super.onInit();
  }

  _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      isLoading.value = true;
      getNews();
    }
  }

  getNews({searchKey = '', reload = false}) async {
    notFound.value = false;

    if (!reload && isLoading.value == false) {
    } else {
      country.value = '';
    }

    if (isLoading.value == true) {
      pageNum++;
    } else {
      news = [];

      pageNum.value = 1;
    }

    baseApi = "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&";
    baseApi += country == '' ? 'country=in&' : 'country=$country&';
    baseApi += 'apiKey=d28588e6c8694054bee000b4e6ce9fbb';

    if (searchKey != '') {
      country.value = '';
      baseApi =
          "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&q=$searchKey&apiKey=d28588e6c8694054bee000b4e6ce9fbb";
    }
    print(baseApi);
    getDataFromApi(baseApi);
  }

  getDataFromApi(url) async {
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      NewsModel newsData = NewsModel.fromJson(jsonDecode(res.body));

      if (newsData.articles.isEmpty && newsData.totalResults == 0) {
        notFound.value = isLoading.value == true ? false : true;
        isLoading.value = false;
        update();
      } else {
        if (isLoading.value == true) {
          news = [...news, ...newsData.articles];
          update();
        } else {
          if (newsData.articles.isNotEmpty) {
            news = newsData.articles;
            if (scrollController.hasClients) scrollController.jumpTo(0.0);
            update();
          }
        }
        notFound.value = false;
        isLoading.value = false;
        update();
      }
    } else {
      notFound.value = true;
      update();
    }
  }
}
