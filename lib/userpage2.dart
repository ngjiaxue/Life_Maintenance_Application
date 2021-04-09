import 'package:cached_network_image/cached_network_image.dart';

import 'user.dart';
import 'additem.dart';
import 'methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';

class UserPage2 extends StatefulWidget {
  final User user;
  // final List foodList;
  // final List userFoodList;
  const UserPage2({
    Key key,
    this.user,
    // this.foodList, this.userFoodList
  }) : super(key: key);
  @override
  _UserPage2State createState() => _UserPage2State();
}

class _UserPage2State extends State<UserPage2>
    with AutomaticKeepAliveClientMixin {
  Methods methods = new Methods();
  double _screenHeight;
  AssetImage _gif;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _screenHeight = MediaQuery.of(context).size.height;
    _gif = AssetImage("assets/images/logowithtext.gif");
    return Container(
      child: Stack(
        children: [
          // widget.userFoodList.length == 0
          widget.user.getUserFoodList().length == 0
              ? Center(
                  child: methods.noRecordFound(5, 24.0),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  // itemCount: widget.userFoodList.length,
                  itemCount: widget.user.getUserFoodList().length,
                  itemBuilder: (context, index) {
                    // int _count = (widget.userFoodList.length - 1) - index;
                    return Container(
                      height: _screenHeight / 2.5,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Container(
                                height: _screenHeight / 3,
                                width: double.infinity,
                                child: Card(
                                  elevation: 10.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    side: BorderSide(
                                      width: 3,
                                      color: index % 5 == 0
                                          ? Color(0XFF015F9F)
                                          : index % 5 == 1
                                              ? Color(0XFF00D1D0)
                                              : index % 5 == 2
                                                  ? Color(0XFF00CC49)
                                                  : index % 5 == 3
                                                      ? Color(0XFFFA9308)
                                                      : Color(0XFFEE1F27),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: _screenHeight / 4.58,
                                          width: _screenHeight / 4.38,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              methods.textOnly(
                                                  widget.user.getUserFoodList()[
                                                      index]["name"],
                                                  "Leoscar",
                                                  32.0,
                                                  Colors.black,
                                                  FontWeight.normal,
                                                  FontStyle.normal,
                                                  TextAlign.start),
                                              Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 15.0,
                                                ),
                                                child: methods.textOnly(
                                                    "${widget.user.getUserFoodList()[index]["calories"]} calories (per 100 grams)",
                                                    "Leoscar",
                                                    18.0,
                                                    Colors.black,
                                                    FontWeight.normal,
                                                    FontStyle.normal,
                                                    TextAlign.start),
                                              ),
                                              Spacer(),
                                              methods.textOnly(
                                                  "Amount taken: ${double.parse(widget.user.getUserFoodList()[index]["amount"]).toStringAsFixed(1)} grams",
                                                  "Leoscar",
                                                  18.0,
                                                  Colors.black,
                                                  FontWeight.normal,
                                                  FontStyle.normal,
                                                  TextAlign.start),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: methods.textOnly(
                                              "Total calories: ${widget.user.getUserFoodList()[index]["totalcalories"]} calories",
                                              "Leoscar",
                                              18.0,
                                              Colors.black,
                                              FontWeight.normal,
                                              FontStyle.normal,
                                              TextAlign.start),
                                        ),
                                        Spacer(),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: methods.textOnly(
                                              "Date added: ${widget.user.getUserFoodList()[index]["date"]}",
                                              "Leoscar",
                                              12.0,
                                              Colors.black,
                                              FontWeight.normal,
                                              FontStyle.normal,
                                              TextAlign.end),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10.0,
                              ),
                              child: Container(
                                height: _screenHeight / 4,
                                width: _screenHeight / 4,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  height: _screenHeight / 4,
                                  width: _screenHeight / 4,
                                  imageUrl: widget.user.getUserFoodList()[index]
                                      ["imagesource"],
                                  placeholder: (context, url) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: _gif,
                                        scale: 5,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          "assets/images/defaultprofile.png"),
                                ),
                                // child: Image.network(
                                //   widget.user.getUserFoodList()[index]["imagesource"],
                                // ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 20.0,
                bottom: 20.0,
              ),
              child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.black12),
                  ),
                  child: methods.shaderMask(
                    Icon(
                      FlutterIcons.addfile_ant,
                      size: 30.0,
                      color: Colors.white,
                    ),
                    true,
                  ),
                  heroTag: 1,
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: AddItem(
                          option: "food",
                          // dbList: widget.foodList,
                          dbList: widget.user.getFoodList(),
                          user: widget.user,
                        ),
                        type: PageTransitionType.fade,
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
