import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internapp/controller/news_controller.dart';
import 'package:internapp/views/viewsNews.dart';
import 'package:intl/intl.dart';
import 'components/sideDrawer.dart';

class HomeScreen extends StatelessWidget {
  NewsController newsController = Get.put(NewsController());

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: const Text("NewsApp"),
        actions: [
          IconButton(
            onPressed: () {
              newsController.country.value = '';
              newsController.findNews.value = '';
              newsController.cName.value = '';
              newsController.getNews(reload: true);
              newsController.update();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: sideDrawer(newsController),
      body: Container(
        color: Colors.blueGrey[700],
        child: GetBuilder<NewsController>(
          builder: (controller) {
            return controller.notFound.value
                ? const Center(
                    child: Text("Not Found", style: TextStyle(fontSize: 30)))
                : controller.news.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: controller.scrollController,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Card(
                                  color: Colors.blueGrey[400],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: GestureDetector(
                                    onTap: () => Get.to(ViewNews(
                                        newsUrl: controller.news[index].url)),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Column(
                                        children: [
                                          Stack(children: [
                                            controller.news[index].urlToImage ==
                                                    null
                                                ? Container(
                                                    child: Image.network(
                                                        'https://media-cldnry.s-nbcnews.com/image/upload/t_nbcnews-fp-1024-512,f_auto,q_auto:best/newscms/2019_01/2705191/nbc-social-default.png'),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: CachedNetworkImage(
                                                      placeholder: (context,
                                                              url) =>
                                                          Container(
                                                              child:
                                                                  const CircularProgressIndicator()),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                      imageUrl: controller
                                                              .news[index]
                                                              .urlToImage ??
                                                          '',
                                                    ),
                                                  ),
                                            Positioned(
                                              bottom: 8,
                                              right: 8,
                                              child: Card(
                                                elevation: 0,
                                                color: Colors.blueGrey[300]
                                                    ?.withOpacity(0.8),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 8),
                                                  child: Text(
                                                      "${controller.news[index].source.name}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall),
                                                ),
                                              ),
                                            ),
                                          ]),
                                          const SizedBox(height: 10.0),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              color: Colors.blueGrey[700],
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Text(
                                              controller.news[index].title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                                controller
                                                        .news[index].content ??
                                                    controller
                                                        .news[index].title,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  // fontWeight: FontWeight.bold,
                                                  // fontSize: 18
                                                )),
                                          ),
                                          const SizedBox(height: 10.0),
                                          Container(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(DateFormat("dd-MM-yyyy")
                                                  .format(DateTime.parse(
                                                      controller.news[index]
                                                          .publishedAt))),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              index == controller.news.length - 1 &&
                                      controller.isLoading == true
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : const SizedBox(),
                            ],
                          );
                        },
                        itemCount: controller.news.length,
                      );
          },
          init: NewsController(),
        ),
      ),
    );
  }
}
