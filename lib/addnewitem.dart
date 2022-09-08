import 'methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AddNewItem extends StatefulWidget {
  final String option;
  final bool darkMode;
  final bool isAdmin;
  final VoidCallback callback1;
  const AddNewItem(
      {Key key, this.option, this.darkMode, this.isAdmin, this.callback1})
      : super(key: key);
  @override
  _AddNewItemState createState() {
    return _AddNewItemState(
      callback2: () {
        callback1();
      },
    );
  }
}

class _AddNewItemState extends State<AddNewItem> {
  VoidCallback callback2;
  _AddNewItemState({this.callback2});
  Methods methods = new Methods();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _caloriesController = new TextEditingController();
  TextEditingController _urlController = new TextEditingController();
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
  double _calories = 200.0;
  double _screenHeight;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    AssetImage _gif = AssetImage(
      "assets/images/logowithtext.gif",
    );
    _screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _loading == false
            ? Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 80.0,
                        left: 20.0,
                        right: 20.0,
                        bottom: 500.0,
                      ),
                      child: Theme(
                        data: ThemeData(
                          primarySwatch: MaterialColor(0XFF9866B3, _swatch),
                          textSelectionTheme: TextSelectionThemeData(
                            cursorColor: Color(0XFF9866B3),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _textField(
                              "New " + widget.option,
                              _nameController,
                              Icon(widget.option == "food"
                                  ? FlutterIcons.food_apple_outline_mco
                                  : FlutterIcons.running_faw5s),
                            ),
                            _textField(
                              widget.option == "food"
                                  ? "Calories per 100 grams"
                                  : "Calories burned per 30 minutes",
                              _caloriesController,
                              Icon(FlutterIcons.fire_sli),
                            ),
                            _textField(
                              "Image URL (if any)",
                              _urlController,
                              Icon(FlutterIcons.web_mco),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 150.0,
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _loading = true;
                          });
                          await _addToList(_gif);
                          Navigator.of(context).pop();
                          _gif.evict();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: widget.darkMode
                              ? Colors.white70
                              : Colors.white.withOpacity(0.85),
                          elevation: 20.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: BorderSide(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        child: methods.textOnly(
                            "Submit",
                            "Leoscar",
                            18.0,
                            Colors.black,
                            FontWeight.normal,
                            FontStyle.normal,
                            TextAlign.center),
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
                                  "Add a new " + widget.option,
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
      ),
    );
  }

  Widget _textField(String text, TextEditingController controller, Icon icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        onTap: text == "Calories per 100 grams" ||
                text == "Calories burned per 30 minutes"
            ? () {
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
                      return StatefulBuilder(builder: (context, newSetState) {
                        return methods.shaderMask(
                          Container(
                            height: _screenHeight / 4.3,
                            child: Column(
                              children: [
                                Spacer(),
                                methods.textOnly(
                                    widget.option == "food"
                                        ? "Calories per 100 grams"
                                        : "Calories burned per 30 minutes",
                                    "Leoscar",
                                    18.0,
                                    Colors.white,
                                    null,
                                    null,
                                    TextAlign.center),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                          child: Container(
                                            child: Icon(
                                              LineIcons.times,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                          }),
                                      widget.option == "food"
                                          ? DecimalNumberPicker(
                                              minValue: 0,
                                              maxValue: 1000,
                                              decimalPlaces: 1,
                                              value: _calories,
                                              onChanged: (value) {
                                                newSetState(() {
                                                  _calories = value;
                                                });
                                              })
                                          : DecimalNumberPicker(
                                              minValue: 0,
                                              maxValue: 1000,
                                              value: _calories,
                                              onChanged: (value) {
                                                newSetState(() {
                                                  _calories = value;
                                                });
                                              }),
                                      GestureDetector(
                                        child: Container(
                                          child: Icon(
                                            LineIcons.check,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _caloriesController.text =
                                                _calories.toString();
                                          });
                                          SchedulerBinding.instance
                                              .addPostFrameCallback((_) {
                                            Navigator.pop(context);
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
                        );
                      });
                    });
              }
            : () {},
        readOnly: text == "Calories per 100 grams" ||
                text == "Calories burned per 30 minutes"
            ? true
            : false,
        style: TextStyle(
          fontFamily: "Leoscar",
          fontSize: 17.0,
          letterSpacing: 1.0,
        ),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.name,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: text,
          labelStyle: TextStyle(
            fontFamily: "Leoscar",
            fontSize: 17.0,
            letterSpacing: 1.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Future<void> _addToList(AssetImage _gif) async {
    await http.post(
        Uri.parse(
            "https://shrunk-troubleshoot.000webhostapp.com/php/addlist.php"),
        body: {
          "option": widget.option,
          "name": _nameController.text,
          "calories": _caloriesController.text,
          "imagesource": _urlController.text,
          "verify": widget.isAdmin ? "1" : "0",
        }).then((res) {
      if (res.body == "success") {
        callback2();
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
}
