import 'user.dart';
import 'additem.dart';
import 'methods.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserPage2 extends StatefulWidget {
  final User user;
  final VoidCallback callback1;
  const UserPage2({
    Key key,
    this.user,
    this.callback1,
  }) : super(key: key);
  @override
  _UserPage2State createState() {
    return _UserPage2State(
      callback2: () {
        callback1();
      },
    );
  }
}

class _UserPage2State extends State<UserPage2>
    with AutomaticKeepAliveClientMixin {
  VoidCallback callback2;

  _UserPage2State({this.callback2});
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
                                                  widget.user.getDarkMode()
                                                      ? Colors.white70
                                                      : Colors.black,
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
                                                    widget.user.getDarkMode()
                                                        ? Colors.white70
                                                        : Colors.black,
                                                    FontWeight.normal,
                                                    FontStyle.normal,
                                                    TextAlign.start),
                                              ),
                                              Spacer(),
                                              methods.textOnly(
                                                  "Amount taken: ${double.parse(widget.user.getUserFoodList()[index]["amount"]).toStringAsFixed(1)} grams",
                                                  "Leoscar",
                                                  18.0,
                                                  widget.user.getDarkMode()
                                                      ? Colors.white70
                                                      : Colors.black,
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
                                              widget.user.getDarkMode()
                                                  ? Colors.white70
                                                  : Colors.black,
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
                                              widget.user.getDarkMode()
                                                  ? Colors.white70
                                                  : Colors.black,
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
                                height: _screenHeight / 4.3,
                                width: _screenHeight / 4.3,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  height: _screenHeight / 4.3,
                                  width: _screenHeight / 4.3,
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
                  backgroundColor: widget.user.getDarkMode()
                      ? Color(0XFF424242)
                      : Colors.white,
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
                          dbList: widget.user.getFoodList(),
                          user: widget.user,
                          callback1: () async {
                            if (this.mounted) {
                              await _loadUserList("food");
                            }
                          },
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

  Future<void> _loadUserList(String option) async {
    await http.post(
        Uri.parse(
            "https://lifemaintenanceapplication.000webhostapp.com/php/loaduserlist.php"),
        body: {
          "email": widget.user.getEmail(),
          "weight": widget.user.getWeight(),
          "option": option,
        }).then((res) async {
      if (res.body != "no data" && res.body != "connected but no data") {
        var _extractData = json.decode(res.body);
        setState(() {
          widget.user.setUserFoodList(_extractData);
        });
      } else if (res.body == "connected but no data") {
      } else {
        methods.snackbarMessage(
          context,
          Duration(
            seconds: 1,
          ),
          Colors.red[400],
          true,
          methods.textOnly("Please connect to the internet", "Leoscar", 18.0,
              Colors.white, null, null, TextAlign.center),
        );
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
