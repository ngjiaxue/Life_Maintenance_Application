import 'user.dart';
import 'dart:convert';
import 'methods.dart';
import 'addnewitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_maintenance_application/pendingapproval.dart';

class AddItem extends StatefulWidget {
  final String option;
  final List dbList;
  final User user;
  final VoidCallback callback1;
  const AddItem({Key key, this.option, this.dbList, this.user, this.callback1})
      : super(key: key);
  @override
  _AddItemState createState() {
    return _AddItemState(
      callback2: () {
        callback1();
      },
    );
  }
}

class _AddItemState extends State<AddItem> {
  VoidCallback callback2;
  _AddItemState({this.callback2});
  Methods methods = new Methods();
  double _screenHeight;
  double _amount = 100.0;
  int _duration = 30;
  bool _darkMode = false;
  String _oldQuery = "";
  List _dbList = [];
  List _searchList = [];
  List _pendingApprovalList = [];
  bool _menuPressed = false;
  bool _menuInstantPressed = false;

  TextEditingController _searchController = new TextEditingController();
  Map<int, Color> _swatch = {
    50: Color.fromRGBO(152, 102, 187, .1),
    100: Color.fromRGBO(152, 102, 187, .2),
    200: Color.fromRGBO(152, 102, 187, .3),
    300: Color.fromRGBO(152, 102, 187, .4),
    400: Color.fromRGBO(152, 102, 187, .5),
    500: Color.fromRGBO(152, 102, 187, .6),
    600: Color.fromRGBO(152, 102, 187, .7),
    700: Color.fromRGBO(152, 102, 187, .8),
    800: Color.fromRGBO(152, 102, 187, .9),
    900: Color.fromRGBO(152, 102, 187, 1),
  };
  @override
  void initState() {
    _loadPrefDarkMode();
    super.initState();
    setState(() {
      _dbList = widget.dbList;
    });
    _loadPendingApprovalList();
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    AssetImage _gif = AssetImage(
      "assets/images/logowithtext.gif",
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () {
          callback2();
          _gif.evict();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.of(context).pop();
          return;
        },
        child: Stack(
          children: [
            _searchList.isNotEmpty && _searchList[0] == "no data"
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 60.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          methods.textOnly(
                              "No data found...",
                              "Leoscar",
                              22.0,
                              _darkMode ? Colors.white70 : Colors.black,
                              FontWeight.bold,
                              FontStyle.normal,
                              TextAlign.center),
                          methods.shaderMask(
                            GestureDetector(
                              child: Text(
                                "Add a new " + widget.option + "?",
                                style: TextStyle(
                                  fontFamily: "Leoscar",
                                  fontSize: 17.0,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 1.0,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: AddNewItem(
                                      option: widget.option,
                                      darkMode: _darkMode,
                                      isAdmin: widget.user.getIsAdmin(),
                                      callback1: () async {
                                        if (this.mounted) {
                                          await _loadList(widget.option);
                                        }
                                      },
                                    ),
                                    type: PageTransitionType.fade,
                                  ),
                                );
                              },
                            ),
                            false,
                          ),
                        ],
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 70.0,
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: Container(
                        height: _screenHeight / 1.2,
                        child: Scaffold(
                          body: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: _searchList.isNotEmpty
                                ? _searchList.length
                                : _dbList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: methods.textOnly(
                                    _searchList.isNotEmpty
                                        ? _searchList[index]["name"]
                                        : _dbList[index]["name"],
                                    "Leoscar",
                                    17.0,
                                    _darkMode ? Colors.white70 : Colors.black,
                                    FontWeight.normal,
                                    FontStyle.normal,
                                    TextAlign.left),
                                trailing: Icon(
                                  FlutterIcons.keyboard_arrow_right_mdi,
                                  color:
                                      _darkMode ? Colors.white70 : Colors.black,
                                ),
                                onTap: () {
                                  _gif.evict();
                                  bool _loading = false;
                                  FocusScope.of(context).unfocus();
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
                                        return StatefulBuilder(
                                            builder: (context, newSetState) {
                                          return _loading == false
                                              ? methods.shaderMask(
                                                  Container(
                                                    height: _screenHeight / 4.3,
                                                    child: Column(
                                                      children: [
                                                        Spacer(),
                                                        methods.textOnly(
                                                            "Please insert " +
                                                                (widget.option ==
                                                                        "food"
                                                                    ? "amount (grams)"
                                                                    : "duration (minutes)"),
                                                            "Leoscar",
                                                            18.0,
                                                            Colors.white,
                                                            null,
                                                            null,
                                                            TextAlign.center),
                                                        Padding(
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
                                                                    child: Icon(
                                                                      LineIcons
                                                                          .times,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    _gif.evict();
                                                                    setState(
                                                                        () {
                                                                      _amount =
                                                                          100.0;
                                                                      _duration =
                                                                          30;
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                  }),
                                                              widget.option ==
                                                                      "food"
                                                                  ? DecimalNumberPicker(
                                                                      minValue:
                                                                          0,
                                                                      maxValue:
                                                                          10000,
                                                                      decimalPlaces:
                                                                          1,
                                                                      value:
                                                                          _amount,
                                                                      onChanged:
                                                                          (value) {
                                                                        newSetState(
                                                                            () {
                                                                          _amount =
                                                                              value;
                                                                        });
                                                                      })
                                                                  : NumberPicker(
                                                                      minValue:
                                                                          0,
                                                                      maxValue:
                                                                          200,
                                                                      value:
                                                                          _duration,
                                                                      onChanged:
                                                                          (value) {
                                                                        newSetState(
                                                                            () {
                                                                          _duration =
                                                                              value;
                                                                        });
                                                                      }),
                                                              GestureDetector(
                                                                child:
                                                                    Container(
                                                                  child: Icon(
                                                                    LineIcons
                                                                        .check,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  _gif.evict();
                                                                  newSetState(
                                                                      () {
                                                                    _loading =
                                                                        true;
                                                                  });
                                                                  await _addToList(
                                                                      _searchList.isNotEmpty
                                                                          ? _searchList[
                                                                              index]
                                                                          : _dbList[
                                                                              index],
                                                                      widget.option ==
                                                                              "food"
                                                                          ? _amount
                                                                              .toString()
                                                                          : _duration
                                                                              .toString());
                                                                  SchedulerBinding
                                                                      .instance
                                                                      .addPostFrameCallback(
                                                                          (_) {
                                                                    Navigator.pop(
                                                                        context);
                                                                    setState(
                                                                        () {
                                                                      _amount =
                                                                          100.0;
                                                                      _duration =
                                                                          30;
                                                                    });
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
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: _gif,
                                                      scale: 3,
                                                    ),
                                                  ),
                                                );
                                        });
                                      });
                                },
                              );
                            },
                          ),
                        ),
                      ),
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
                          callback2();
                          _gif.evict();
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                            "Add new " + widget.option,
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
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 70.0,
                  left: 20.0,
                  right: 20.0,
                ),
                child: Theme(
                  data: ThemeData(
                    primarySwatch: MaterialColor(0XFF9866B3, _swatch),
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: Color(0XFF9866B3),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (String _query) {
                        _queryList(_query, false);
                      },
                      style: TextStyle(
                        fontFamily: "Leoscar",
                        fontSize: 17.0,
                        letterSpacing: 1.0,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: Icon(
                          FlutterIcons.search1_ant,
                          size: 20.0,
                        ),
                        suffixIcon: Visibility(
                          visible: _searchController.text.isNotEmpty,
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Icon(
                              FlutterIcons.close_circle_outline_mco,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchList.clear();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          right: 8.0,
          bottom: 8.0,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 142.0),
              child: widget.user.getIsAdmin()
                  ? methods.fab(
                      2,
                      _pendingApprovalList.length,
                      "Pending Approval",
                      () {
                        setState(() {
                          _menuInstantPressed = false;
                        });
                        Future.delayed(const Duration(milliseconds: 1300), () {
                          setState(() {
                            _menuPressed = false;
                          });
                          Navigator.push(
                            context,
                            PageTransition(
                              child: PendingApproval(
                                option: widget.option,
                                darkMode: _darkMode,
                                isAdmin: widget.user.getIsAdmin(),
                                pendingApprovalList: _pendingApprovalList,
                                callback1: () async {
                                  if (this.mounted) {
                                    await _loadList(widget.option);
                                    await _loadPendingApprovalList();
                                  }
                                },
                              ),
                              type: PageTransitionType.fade,
                            ),
                          );
                        });
                      },
                      Icons.pending_actions_rounded,
                      Icons.pending_actions_rounded,
                      false,
                      _menuPressed,
                      _menuInstantPressed,
                      widget.user.getDarkMode(),
                    )
                  : SizedBox.shrink(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: methods.fab(
                3,
                0,
                "Add a new " + widget.option + "?",
                () {
                  setState(() {
                    _menuInstantPressed = false;
                  });
                  Future.delayed(const Duration(milliseconds: 900), () {
                    setState(() {
                      _menuPressed = false;
                    });
                    Navigator.push(
                      context,
                      PageTransition(
                        child: AddNewItem(
                          option: widget.option,
                          darkMode: _darkMode,
                          isAdmin: widget.user.getIsAdmin(),
                          callback1: () async {
                            if (this.mounted) {
                              await _loadList(widget.option);
                            }
                          },
                        ),
                        type: PageTransitionType.fade,
                      ),
                    );
                  });
                },
                widget.option == "food"
                    ? FlutterIcons.food_apple_outline_mco
                    : FlutterIcons.running_faw5s,
                widget.option == "food"
                    ? FlutterIcons.food_apple_outline_mco
                    : FlutterIcons.running_faw5s,
                false,
                _menuPressed,
                _menuInstantPressed,
                widget.user.getDarkMode(),
              ),
            ),
            methods.fab(
              4,
              0,
              "",
              () {
                setState(() {
                  _menuPressed = true;
                  _menuInstantPressed = false;
                });
                Future.delayed(const Duration(milliseconds: 900), () {
                  setState(() {
                    _menuPressed = false;
                  });
                });
              },
              Icons.close,
              Icons.close,
              false,
              _menuPressed,
              _menuInstantPressed,
              widget.user.getDarkMode(),
            ),
            methods.fab(
                5,
                _pendingApprovalList.length,
                "",
                _menuPressed
                    ? () {}
                    : () {
                        setState(() {
                          _menuPressed = true;
                          _menuInstantPressed = true;
                        });
                      },
                Icons.menu,
                Icons.menu,
                false,
                _menuPressed,
                _menuInstantPressed,
                widget.user.getDarkMode()),
          ],
        ),
      ),
    );
  }

  _queryList(String _query, bool fromNewItem) {
    setState(() {
      _searchList.clear();
    });
    bool _atLeastOneData = false;
    // if (_oldQuery.length != _query.length ||
    //     _query.substring(_query.length - 1, _query.length) == " " ||
    //     fromNewItem) {
    //   setState(() {
    //     _searchList.clear();
    //   });
    // }
    if (_query.isNotEmpty) {
      for (int _i = 0; _i < _dbList.length; _i++) {
        if (_dbList[_i]["name"].toLowerCase().contains(_query.toLowerCase())) {
          setState(() {
            _searchList.add(_dbList[_i]);
            _atLeastOneData = true;
          });
        }
      }
    } else {
      setState(() {
        _searchList.clear();
      });
    }
    if (_query.isNotEmpty && _atLeastOneData == false) {
      _searchList.add("no data");
    }
    _oldQuery = _query;
    print(_searchList);
  }

  Future<void> _addToList(Map<String, dynamic> list, String amount) async {
    await http.post(
        Uri.parse(
            "https://lifemaintenanceapplication.000webhostapp.com/php/adduserlist.php"),
        body: {
          "email": widget.user.getEmail(),
          "id": list["id"],
          "amount": amount,
          "option": widget.option,
        }).then((res) {
      if (res.body == "success") {
        methods.snackbarMessage(
          context,
          Duration(
            milliseconds: 1500,
          ),
          Color(0XFFB563E0),
          true,
          methods.textOnly("Added successfully", "Leoscar", 18.0, Colors.white,
              null, null, TextAlign.center),
        );
      } else {
        methods.snackbarMessage(
          context,
          Duration(
            seconds: 1,
          ),
          Colors.red[400],
          true,
          methods.textOnly("Fail to add...Please try again", "Leoscar", 18.0,
              Colors.white, null, null, TextAlign.center),
        );
      }
    });
  }

  Future<void> _loadPrefDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool darkMode = (prefs.getBool('darkmode')) ?? false;
    print("darkmodeMyApp: $darkMode");
    setState(() {
      _darkMode = darkMode;
    });
  }

  Future<void> _loadList(String option) async {
    await http.post(
        Uri.parse(
            "https://lifemaintenanceapplication.000webhostapp.com/php/loadlist.php"),
        body: {
          "option": option,
        }).then((res) async {
      if (res.body != "no data") {
        var _extractData = json.decode(res.body);
        if (option == "food") {
          setState(() {
            widget.user.setFoodList(_extractData);
            _dbList = _extractData;
          });
        } else {
          setState(() {
            widget.user.setExerciseList(_extractData);
            _dbList = _extractData;
          });
        }
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
    }).whenComplete(() {
      _queryList(_searchController.text, true);
    });
  }

  Future<void> _loadPendingApprovalList() async {
    await http.post(
        Uri.parse(
            "https://lifemaintenanceapplication.000webhostapp.com/php/loadpendingapprovallist.php"),
        body: {
          "option": widget.option,
        }).then((res) {
      if (res.body != "no data") {
        var _extractData = json.decode(res.body);
        setState(() {
          _pendingApprovalList = _extractData;
        });
      }
    });
  }
}
