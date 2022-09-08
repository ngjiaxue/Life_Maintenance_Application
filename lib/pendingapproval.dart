import 'methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PendingApproval extends StatefulWidget {
  final String option;
  final bool darkMode;
  final bool isAdmin;
  final List pendingApprovalList;
  final VoidCallback callback1;
  const PendingApproval({
    Key key,
    this.option,
    this.darkMode,
    this.isAdmin,
    this.pendingApprovalList,
    this.callback1,
  }) : super(key: key);
  @override
  _PendingApprovalState createState() {
    return _PendingApprovalState(
      callback2: () {
        callback1();
      },
    );
  }
}

class _PendingApprovalState extends State<PendingApproval> {
  VoidCallback callback2;
  _PendingApprovalState({this.callback2});
  Methods methods = new Methods();
  double _screenHeight;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    AssetImage _gif = AssetImage(
      "assets/images/logowithtext.gif",
    );
    _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _loading == false
          ? Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 80.0,
                  ),
                  child: widget.pendingApprovalList.length > 0
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: widget.pendingApprovalList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: _screenHeight / 7,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Container(
                                        height: _screenHeight / 8.5,
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
                                                              ? Color(
                                                                  0XFFFA9308)
                                                              : Color(
                                                                  0XFFEE1F27),
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
                                                              ? Color(
                                                                  0XFFFA9308)
                                                              : Color(
                                                                  0XFFEE1F27),
                                              onTap: () async {
                                                showModalBottomSheet(
                                                    context: context,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                10.0),
                                                        topRight:
                                                            Radius.circular(
                                                                10.0),
                                                      ),
                                                    ),
                                                    builder:
                                                        (BuildContext context) {
                                                      return StatefulBuilder(
                                                          builder: (context,
                                                              newSetState) {
                                                        return _loading == false
                                                            ? methods
                                                                .shaderMask(
                                                                Container(
                                                                  height:
                                                                      _screenHeight /
                                                                          10,
                                                                  child:
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
                                                                              FlutterIcons.cancel_mco,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                          onTap:
                                                                              () async {
                                                                            _gif.evict();
                                                                            Navigator.pop(context);
                                                                            await _verifyApproval(index,
                                                                                false);
                                                                          },
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            left:
                                                                                20.0,
                                                                            right:
                                                                                3.0,
                                                                            bottom:
                                                                                7.0,
                                                                          ),
                                                                          child: methods.textOnly(
                                                                              "☜",
                                                                              "Leoscar",
                                                                              26.0,
                                                                              Colors.white,
                                                                              null,
                                                                              null,
                                                                              TextAlign.center),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            top:
                                                                                3.0,
                                                                          ),
                                                                          child: methods.textOnly(
                                                                              "Decline",
                                                                              "Leoscar",
                                                                              18.0,
                                                                              Colors.white,
                                                                              null,
                                                                              null,
                                                                              TextAlign.center),
                                                                        ),
                                                                        Spacer(),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            top:
                                                                                3.0,
                                                                          ),
                                                                          child: methods.textOnly(
                                                                              "Approve",
                                                                              "Leoscar",
                                                                              18.0,
                                                                              Colors.white,
                                                                              null,
                                                                              null,
                                                                              TextAlign.center),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            left:
                                                                                3.0,
                                                                            right:
                                                                                20.0,
                                                                            bottom:
                                                                                7.0,
                                                                          ),
                                                                          child: methods.textOnly(
                                                                              "☞",
                                                                              "Leoscar",
                                                                              26.0,
                                                                              Colors.white,
                                                                              null,
                                                                              null,
                                                                              TextAlign.center),
                                                                        ),
                                                                        GestureDetector(
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Icon(
                                                                              LineIcons.check,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                          onTap:
                                                                              () async {
                                                                            _gif.evict();
                                                                            Navigator.pop(context);
                                                                            await _verifyApproval(index,
                                                                                true);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
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
                                                                    scale: 5,
                                                                  ),
                                                                ),
                                                              );
                                                      });
                                                    });
                                              },
                                              child: Container(
                                                height: _screenHeight / 12,
                                                width: _screenHeight,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    methods.textOnly(
                                                        widget.pendingApprovalList[
                                                            index]["name"],
                                                        "Leoscar",
                                                        32.0,
                                                        widget.darkMode
                                                            ? Colors.white70
                                                            : Colors.black,
                                                        FontWeight.normal,
                                                        FontStyle.normal,
                                                        TextAlign.start),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 15.0,
                                                      ),
                                                      child: methods.textOnly(
                                                          "${widget.pendingApprovalList[index]["calories"]} calories (per 100 grams)",
                                                          "Leoscar",
                                                          18.0,
                                                          widget.darkMode
                                                              ? Colors.white70
                                                              : Colors.black,
                                                          FontWeight.normal,
                                                          FontStyle.normal,
                                                          TextAlign.start),
                                                    ),
                                                  ],
                                                ),
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
                                        right: 10.0,
                                        bottom: 20.0,
                                      ),
                                      child: Container(
                                        height: _screenHeight / 7,
                                        width: _screenHeight / 7,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          height: _screenHeight / 7,
                                          width: _screenHeight / 7,
                                          imageUrl:
                                              widget.pendingApprovalList[index]
                                                          ["imagesource"] ==
                                                      null
                                                  ? ""
                                                  : widget.pendingApprovalList[
                                                      index]["imagesource"],
                                          placeholder: (context, url) =>
                                              Container(
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
                          })
                      : Center(
                          child: methods.noRecordFound(7, 20.0),
                        ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      left: 10.0,
                    ),
                    child: Row(
                      children: [
                        methods.shaderMask(
                          IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Icon(
                              FlutterIcons.md_arrow_round_back_ion,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          true,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            top: 7.0,
                          ),
                          child: methods.shaderMask(
                            methods.textOnly(
                                "Pending Approval",
                                "Leoscar",
                                22.0,
                                Colors.white,
                                FontWeight.bold,
                                FontStyle.normal,
                                TextAlign.center),
                            true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _gif,
                  scale: 3,
                ),
              ),
            ),
    );
  }

  Future<void> _verifyApproval(int index, bool approve) async {
    setState(() {
      _loading = true;
    });
    await http.post(
        Uri.parse(
            "https://shrunk-troubleshoot.000webhostapp.com/php/verifyapproval.php"),
        body: {
          "approve": approve.toString(),
          "id": widget.pendingApprovalList[index]["id"],
          "option": widget.option,
        }).then((res) {
      if (res.body == "success") {
        for (int _i = 0; _i < widget.pendingApprovalList.length; _i++) {
          if (widget.pendingApprovalList[_i]["id"] ==
              widget.pendingApprovalList[index]["id"]) {
            widget.pendingApprovalList.removeAt(_i);
          }
        }
        callback2();
        methods.snackbarMessage(
          context,
          Duration(
            seconds: 1,
          ),
          Color(0XFFB563E0),
          true,
          methods.textOnly("Operation successful", "Leoscar", 18.0,
              Colors.white, null, null, TextAlign.center),
        );
      } else {
        methods.snackbarMessage(
          context,
          Duration(
            seconds: 1,
          ),
          Colors.red[400],
          true,
          methods.textOnly("Operation failed...Please try again", "Leoscar",
              18.0, Colors.white, null, null, TextAlign.center),
        );
      }
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }
}
