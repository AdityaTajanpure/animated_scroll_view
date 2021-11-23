import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lukecoutinho/model/health_recipe.dart';
import 'package:lukecoutinho/utils/constants.dart';

class RecipePage extends StatefulWidget {
  final int index;
  final String heroTag;
  final HealthRecipe recipe;
  const RecipePage({Key key, this.index, this.heroTag, this.recipe})
      : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  ScrollController scrollController;
  var top = 0.0;
  double imageSize = 150;
  double initialSize = 150;
  double imageOpacity = 1;
  double offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      imageSize = initialSize - scrollController.offset;
      imageOpacity = imageSize / initialSize;
      offset = scrollController.offset;

      if (imageSize < 0) {
        imageSize = 0;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Color.fromRGBO(255, 223, 208, 1),
                expandedHeight: 200.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                floating: false,
                pinned: true,
                elevation: 0,
                leading: Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.chevron_left,
                      color: Colors.black,
                      size: 22,
                    )),
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    top = constraints.biggest.height;
                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      centerTitle: false,
                      title: AnimatedOpacity(
                          duration: Duration(milliseconds: 300),
                          opacity: top ==
                                  MediaQuery.of(context).padding.top +
                                      kToolbarHeight
                              ? 1.0
                              : 0.0,
                          child: Text(
                            widget.recipe.title,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                overflow: TextOverflow.clip),
                          )),
                      background: Image.asset(
                        'assets/images/Group.png',
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ];
          },
          body: Container(),
        ),
        Positioned(
          top: 140 - offset,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            opacity: imageOpacity.clamp(0.0, 1.0),
            duration: Duration(milliseconds: 300),
            child: Padding(
                padding: const EdgeInsets.only(left: 12, top: 16, right: 12),
                child: Hero(
                  tag: widget.heroTag,
                  child: CachedNetworkImage(
                    imageUrl: widget.recipe != null &&
                            widget.recipe.recipeImages != null &&
                            widget.recipe.recipeImages.isNotEmpty
                        ? widget.recipe.recipeImages[0]
                        : "https://firebasestorage.googleapis.com/v0/b/testproject-edb7b.appspot.com/o/Luke'sGurukul%2FlukeMantra%2FRectangle.png?alt=media&token=08e3d681-f1cb-482f-8789-07c7e90c6a51",
                    width: imageSize,
                    height: imageSize,
                    placeholder: (context, url) =>
                        Constants().getShimmer(context, 100, 100, 10),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    //fit: BoxFit.fill,
                  ),
                )),
          ),
        ),
      ],
    ));
  }
}
