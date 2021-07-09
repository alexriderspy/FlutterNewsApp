import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/helper/data.dart';
import 'package:flutter_news_app/helper/news.dart';
import 'package:flutter_news_app/models/article_model.dart';
import 'package:flutter_news_app/models/category_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = <CategoryModel>[];
  List<ArticleModel> articles = <ArticleModel>[];

  bool _loading = true;
  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  //this gets called first when we hot restart
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //appbar is the topmost bar, we want there 2 pieces of text-Flutter, News
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Flutter",
                textScaleFactor: 1.4,
              ),
              Text(
                "News",
                style: TextStyle(color: Colors.blue),
                textScaleFactor: 1.4,
              )
            ],
          ),
          elevation: 0.0,
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView( //to treat bootom overflowed
            child : Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    Container(
                      
                      height: 70,
                      child: ListView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        
                        scrollDirection: Axis.horizontal,
                        //must for column
                        itemBuilder: (context, index) {
                          return CategoryTile(
                              imageUrl: categories[index].imageUrl,
                              categoryName:
                                  categories[index].categoryName); //a widget
                        },
                      ),
                    ),
                    //blogs
                  Container(
                    padding: EdgeInsets.only(top: 16),
                    child: ListView.builder(
                      itemCount: articles.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(), //enable scrolling
                      itemBuilder: (context, index) {
                        //return a widget
                        return BlogTile(
                            imageUrl: articles[index].urltoImage,
                            title: articles[index].title,
                            desc: articles[index].description);
                      },
                    ))
                  ],
                ), //has more than 1 child -> horizontal list view and vertical, arranged in a column
              )
            )
          );
    //container returns black bg, scaffold returns white bg
  }
}
//first building the UI then getting and fetching data

//this is the individual category tile
class CategoryTile extends StatelessWidget {
  final imageUrl, categoryName;
  CategoryTile({this.imageUrl, this.categoryName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 120, 
                        height: 90, 
                        fit: BoxFit.cover
                      )
                    ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              width: 120,
              height: 90,
              child: Text(categoryName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc;
  BlogTile({required this.imageUrl, required this.title, required this.desc});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6)
      ),
      child: Column(
        children: <Widget>[
          CachedNetworkImage(imageUrl: imageUrl), 
          Text(title, 
            style: TextStyle(
              color: Colors.black87,
              fontSize: 17),
          ), 
          Text(desc, style: TextStyle(color: Colors.black54),)],
      ),
    );
  }
}
