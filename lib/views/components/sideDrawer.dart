import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internapp/controller/news_controller.dart';
import 'package:internapp/model/utils.dart';
import 'package:internapp/views/components/dropDownList.dart';

Drawer sideDrawer(NewsController newsController) {
  return Drawer(
    child: ListView(
      // padding: EdgeInsets.symmetric(vertical: 60),
      children: [
        GetBuilder<NewsController>(
          builder: (controller) {
            return Container(
              color: Colors.blueGrey[400],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.cName != ''
                      ? Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            controller.cName.value,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))
                      : Container(),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
          init: NewsController(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: TextFormField(
                  decoration: const InputDecoration(hintText: "Find Keyword"),
                  scrollPadding: const EdgeInsets.all(5),
                  onChanged: (val) {
                    newsController.findNews.value = val;
                    newsController.update();
                  },
                ),
              ),
            ),
            MaterialButton(
              child: const Text("Find"),
              onPressed: () async {
                newsController.getNews(
                    searchKey: newsController.findNews.value);
              },
            ),
          ],
        ),
        ExpansionTile(
          title: const Text("Country"),
          children: <Widget>[
            for (int i = 0; i < listOfCountry.length; i++)
              dropDownList(
                call: () {
                  newsController.country.value = listOfCountry[i]['code']!;
                  newsController.cName.value =
                      listOfCountry[i]['name']!.toUpperCase();
                  newsController.getNews();
                 newsController.update();
                },
                name: listOfCountry[i]['name']!.toUpperCase(),
              ),
          ],
        ),
        ListTile(title: const Text("Close"), onTap: () => Get.back()),
      ],
    ),
  );
}
