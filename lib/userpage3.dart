import 'user.dart';
import 'additem.dart';
import 'methods.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart';
import 'package:line_icons/line_icons.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserPage3 extends StatefulWidget {
  final User user;
  // final List exerciseList;
  // final List userExerciseList;
  final VoidCallback callback1;
  final Function(int) func1;
  const UserPage3(
      {Key key,
      this.callback1,
      // this.exerciseList,
      // this.userExerciseList,
      this.func1,
      this.user})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _UserPage3State(callback2: () {
      callback1();
    }, func2: (integer) {
      func1(integer);
    });
  }
}

class _UserPage3State extends State<UserPage3>
    with AutomaticKeepAliveClientMixin {
  VoidCallback callback2;
  Function(int) func2;
  _UserPage3State({this.callback2, this.func2});
  Methods methods = new Methods();
  double _screenHeight;
  double _newAmount = 0.0;
  bool _loading = false;
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
          // widget.userExerciseList.length == 0
          widget.user.getUserExerciseList().length == 0
              ? Center(
                  child: methods.noRecordFound(5, 24.0),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  // itemCount: widget.userExerciseList.length,
                  itemCount: widget.user.getUserExerciseList().length,
                  itemBuilder: (context, index) {
                    // int _count =
                    //     (widget.user.getExerciseList().length - 1) - index;
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
                                    child: InkWell(
                                      splashColor: index % 5 == 0
                                          ? Color(0XFF015F9F)
                                          : index % 5 == 1
                                              ? Color(0XFF00D1D0)
                                              : index % 5 == 2
                                                  ? Color(0XFF00CC49)
                                                  : index % 5 == 3
                                                      ? Color(0XFFFA9308)
                                                      : Color(0XFFEE1F27),
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            enableDrag: false,
                                            isDismissible: false,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                            ),
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(builder:
                                                  (context, newSetState) {
                                                return _loading == false
                                                    ? methods.shaderMask(
                                                        Container(
                                                          height:
                                                              _screenHeight /
                                                                  4.3,
                                                          child: Column(
                                                            children: [
                                                              Spacer(),
                                                              methods.textOnly(
                                                                  "Update exercise duration",
                                                                  "Leoscar",
                                                                  18.0,
                                                                  Colors.white,
                                                                  null,
                                                                  null,
                                                                  TextAlign
                                                                      .center),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      30.0,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    GestureDetector(
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Icon(
                                                                          LineIcons
                                                                              .times,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _newAmount =
                                                                              0;
                                                                        });
                                                                        _gif.evict();
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                    DecimalNumberPicker(
                                                                        minValue:
                                                                            0,
                                                                        maxValue:
                                                                            5000,
                                                                        decimalPlaces:
                                                                            1,
                                                                        value: _newAmount ==
                                                                                0.0
                                                                            ? double.parse(widget.user.getUserExerciseList()[index][
                                                                                "amount"])
                                                                            : _newAmount,
                                                                        onChanged:
                                                                            (value) {
                                                                          newSetState(
                                                                              () {
                                                                            _newAmount =
                                                                                value;
                                                                          });
                                                                        }),
                                                                    GestureDetector(
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Icon(
                                                                          LineIcons
                                                                              .check,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () async {
                                                                        newSetState(
                                                                            () {
                                                                          _loading =
                                                                              true;
                                                                        });
                                                                        await _editUserList(
                                                                            "exercise",
                                                                            _newAmount != 0.0
                                                                                ? _newAmount.toStringAsFixed(1)
                                                                                : widget.user.getUserExerciseList()[index]["amount"],
                                                                            widget.user.getUserExerciseList()[index]["date"],
                                                                            widget.user.getEmail());
                                                                        Navigator.pop(
                                                                            context);
                                                                        SchedulerBinding
                                                                            .instance
                                                                            .addPostFrameCallback((_) {
                                                                          _loading =
                                                                              false;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        true,
                                                      )
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: _gif,
                                                            scale: 3,
                                                          ),
                                                        ),
                                                      );
                                              });
                                            }).whenComplete(() {
                                          setState(() {
                                            _newAmount = 0.0;
                                          });
                                        });
                                      },
                                      onLongPress: () {
                                        showModalBottomSheet(
                                            context: context,
                                            enableDrag: false,
                                            isDismissible: false,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                            ),
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(builder:
                                                  (context, newSetState) {
                                                return _loading == false
                                                    ? Container(
                                                        height:
                                                            _screenHeight / 11,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 30.0,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              GestureDetector(
                                                                child:
                                                                    Container(
                                                                  child: methods
                                                                      .shaderMask(
                                                                    Icon(
                                                                      LineIcons
                                                                          .times,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    true,
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  setState(() {
                                                                    _newAmount =
                                                                        0;
                                                                  });
                                                                  _gif.evict();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              methods
                                                                  .shaderMask(
                                                                methods.textOnly(
                                                                    "Delete selected exercise?",
                                                                    "Leoscar",
                                                                    18.0,
                                                                    Colors
                                                                        .white,
                                                                    FontWeight
                                                                        .normal,
                                                                    FontStyle
                                                                        .normal,
                                                                    TextAlign
                                                                        .start),
                                                                true,
                                                              ),
                                                              GestureDetector(
                                                                child:
                                                                    Container(
                                                                  child: methods
                                                                      .shaderMask(
                                                                    Icon(
                                                                      LineIcons
                                                                          .check,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    true,
                                                                  ),
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  newSetState(
                                                                      () {
                                                                    _loading =
                                                                        true;
                                                                  });
                                                                  await _deleteUserList(
                                                                      "exercise",
                                                                      widget.user
                                                                              .getUserExerciseList()[index]
                                                                          [
                                                                          "amount"],
                                                                      widget.user.getUserExerciseList()[
                                                                              index]
                                                                          [
                                                                          "date"],
                                                                      widget
                                                                          .user
                                                                          .getEmail());
                                                                  Navigator.pop(
                                                                      context);
                                                                  SchedulerBinding
                                                                      .instance
                                                                      .addPostFrameCallback(
                                                                          (_) {
                                                                    _loading =
                                                                        false;
                                                                  });
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: _gif,
                                                            scale: 3,
                                                          ),
                                                        ),
                                                      );
                                              });
                                            });
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            // color: Colors.orange,
                                            height: _screenHeight / 4.58,
                                            width: _screenHeight / 4.38,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                methods.textOnly(
                                                    widget.user
                                                            .getUserExerciseList()[
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
                                                methods.textOnly(
                                                    "${widget.user.getUserExerciseList()[index]["calories"]} calories burned (per 30 minutes)",
                                                    "Leoscar",
                                                    18.0,
                                                    widget.user.getDarkMode()
                                                        ? Colors.white70
                                                        : Colors.black,
                                                    FontWeight.normal,
                                                    FontStyle.normal,
                                                    TextAlign.start),
                                                Spacer(),
                                                methods.textOnly(
                                                    "Exercise duration: ${widget.user.getUserExerciseList()[index]["amount"]} minutes",
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
                                            // color: Colors.green,
                                            child: methods.textOnly(
                                                "Total calories burned: ${widget.user.getUserExerciseList()[index]["totalcalories"]} calories",
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
                                                "Date added: ${widget.user.getUserExerciseList()[index]["date"]}",
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
                                // color: Colors.pink,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  height: _screenHeight / 4.3,
                                  width: _screenHeight / 4.3,
                                  imageUrl:
                                      widget.user.getUserExerciseList()[index]
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
                                          "assets/images/noimageavailable.png"),
                                ),
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
                  heroTag: 2,
                  onPressed: () {
                    if (widget.user.getWeight() == "0.0") {
                      methods.snackbarMessage(
                        context,
                        Duration(
                          seconds: 1,
                        ),
                        Colors.red[400],
                        true,
                        methods.textOnly("Please insert your weight", "Leoscar",
                            18.0, Colors.white, null, null, TextAlign.center),
                      );
                      func2(4);
                    } else {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: AddItem(
                            option: "exercise",
                            dbList: widget.user.getExerciseList(),
                            user: widget.user,
                            callback1: () async {
                              await _loadUserList("exercise");
                            },
                          ),
                          type: PageTransitionType.fade,
                        ),
                      );
                    }
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
            "https://shrunk-troubleshoot.000webhostapp.com/php/loaduserlist.php"),
        body: {
          "email": widget.user.getEmail(),
          "weight": widget.user.getWeight(),
          "option": option,
        }).then((res) async {
      if (res.body != "no data" && res.body != "connected but no data") {
        var _extractData = json.decode(res.body);
        setState(() {
          widget.user.setUserExerciseList(_extractData);
        });
      } else if (res.body == "connected but no data") {
        setState(() {
          widget.user.setUserExerciseList([]);
        });
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

  Future<void> _editUserList(
      String _option, String _amount, String _date, String _email) async {
    await http.post(
        Uri.parse(
            "https://shrunk-troubleshoot.000webhostapp.com/php/edituserlist.php"),
        body: {
          "option": _option,
          "amount": _amount,
          "date": _date,
          "email": _email,
        }).then((res) async {
      if (res.body == "success") {
        await _loadUserList("exercise");
        SchedulerBinding.instance.addPostFrameCallback((_) {
          methods.snackbarMessage(
            context,
            Duration(
              milliseconds: 1500,
            ),
            Color(0XFFB563E0),
            true,
            methods.textOnly("Exercise duration updated successfully",
                "Leoscar", 18.0, Colors.white, null, null, TextAlign.center),
          );
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          methods.snackbarMessage(
            context,
            Duration(
              seconds: 1,
            ),
            Colors.red[400],
            true,
            methods.textOnly(
                "Failed to update exercise duration...Please try again",
                "Leoscar",
                18.0,
                Colors.white,
                null,
                null,
                TextAlign.center),
          );
        });
      }
    });
  }

  Future<void> _deleteUserList(
      String _option, String _amount, String _date, String _email) async {
    await http.post(
        Uri.parse(
            "https://shrunk-troubleshoot.000webhostapp.com/php/deleteuserlist.php"),
        body: {
          "option": _option,
          "amount": _amount,
          "date": _date,
          "email": _email,
        }).then((res) async {
      if (res.body == "success") {
        await _loadUserList("exercise");
        SchedulerBinding.instance.addPostFrameCallback((_) {
          methods.snackbarMessage(
            context,
            Duration(
              milliseconds: 1500,
            ),
            Color(0XFFB563E0),
            true,
            methods.textOnly("Exercise deleted successfully", "Leoscar", 18.0,
                Colors.white, null, null, TextAlign.center),
          );
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          methods.snackbarMessage(
            context,
            Duration(
              seconds: 1,
            ),
            Colors.red[400],
            true,
            methods.textOnly("Failed to delete exercise...Please try again",
                "Leoscar", 18.0, Colors.white, null, null, TextAlign.center),
          );
        });
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
