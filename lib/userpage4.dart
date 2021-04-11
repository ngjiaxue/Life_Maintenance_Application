import 'dart:io';
import 'dart:ui';
import 'user.dart';
import 'methods.dart';
import 'dart:convert';
import 'loginscreen.dart';
import 'editprofile.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart';
import 'package:line_icons/line_icons.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:slider_button/slider_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class UserPage4 extends StatefulWidget {
  final User user;
  final VoidCallback callback1;
  const UserPage4({Key key, this.user, this.callback1}) : super(key: key);
  @override
  _UserPage4State createState() {
    return _UserPage4State(
      callback2: () {
        callback1();
      },
    );
  }
}

class _UserPage4State extends State<UserPage4>
    with AutomaticKeepAliveClientMixin {
  VoidCallback callback2;
  _UserPage4State({this.callback2});
  Methods methods = new Methods();
  double _screenWidth;
  double _screenHeight;
  double _userNewHeight;
  double _userNewWeight;
  bool _loading = false;
  bool _isCropping = false;
  bool _isEditing = false;
  bool _confirmationMessage = false;
  PickedFile _pickedFile;
  File _image;
  AssetImage _gif;
  Color _darkColor = Color(0XFF424242);
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _dobController = new TextEditingController();
  TextEditingController _genderController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _heightController = new TextEditingController();
  TextEditingController _weightController = new TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    _gif = AssetImage("assets/images/logowithtext.gif");
    return _isCropping == false
        ? Container(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  leading: SizedBox.shrink(),
                  backgroundColor: Colors.transparent,
                  expandedHeight: _screenWidth,
                  flexibleSpace: Container(
                    height: _screenWidth,
                    width: _screenWidth,
                    child: Stack(
                      children: [
                        ClipPath(
                          clipper: ClippingClass(),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: _screenWidth,
                            width: _screenWidth,
                            imageUrl:
                                "https://lifemaintenanceapplication.000webhostapp.com/images/${widget.user.getEmail()}.jpg",
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: _gif,
                                  scale: 5,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Image.asset("assets/images/defaultprofile.png"),
                          ),
                          // Image.asset(
                          //   "assets/images/defaultprofile.png",
                          //   fit: BoxFit.cover,
                          //   height: _screenWidth,
                          //   width: _screenWidth,
                          // ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 50,
                          ),
                          child: ClipPath(
                            clipper: ClippingClass(),
                            child: Container(
                              width: _screenWidth,
                              height: _screenWidth,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: widget.user.getDarkMode()
                                      ? [
                                          _darkColor.withOpacity(0.1),
                                          _darkColor.withOpacity(0.2),
                                          _darkColor.withOpacity(0.3),
                                          _darkColor.withOpacity(0.4),
                                          _darkColor.withOpacity(0.5),
                                          _darkColor.withOpacity(0.6),
                                          _darkColor.withOpacity(0.7),
                                          _darkColor.withOpacity(0.8),
                                          _darkColor.withOpacity(0.9),
                                          _darkColor.withOpacity(1),
                                        ]
                                      : [
                                          Colors.white.withOpacity(0),
                                          Colors.white.withOpacity(0.1),
                                          Colors.white.withOpacity(0.2),
                                          Colors.white.withOpacity(0.3),
                                          Colors.white.withOpacity(0.4),
                                          Colors.white.withOpacity(0.5),
                                          Colors.white.withOpacity(0.6),
                                          Colors.white.withOpacity(0.7),
                                          Colors.white.withOpacity(0.8),
                                          Colors.white.withOpacity(0.9),
                                          Colors.white.withOpacity(1),
                                        ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 30.0,
                            ),
                            child: methods.shaderMask(
                              Text(
                                "Profile",
                                style: TextStyle(
                                  fontFamily: "Leoscar",
                                  fontSize: 36.0,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              true,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 74.0,
                            ),
                            child: Visibility(
                              visible: !_confirmationMessage,
                              child: FloatingActionButton(
                                onPressed: () {
                                  if (!_isEditing) {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                          ),
                                        ),
                                        builder: (BuildContext context) {
                                          return _isCropping == false
                                              ? Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: widget.user
                                                                .getDarkMode()
                                                            ? _darkColor
                                                            : Colors.white,
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
                                                      child: InkWell(
                                                        child: ListTile(
                                                          title: Center(
                                                            child: methods.shaderMask(
                                                                methods.textOnly(
                                                                    "Select from gallery",
                                                                    "Leoscar",
                                                                    17.0,
                                                                    Colors
                                                                        .white,
                                                                    null,
                                                                    null,
                                                                    null),
                                                                true),
                                                          ),
                                                          onTap: () =>
                                                              _getImage(false),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 1.0,
                                                      color: widget.user
                                                              .getDarkMode()
                                                          ? Colors.white30
                                                          : Colors.grey[300],
                                                    ),
                                                    InkWell(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: widget.user
                                                                  .getDarkMode()
                                                              ? _darkColor
                                                              : Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10.0),
                                                          ),
                                                        ),
                                                        child: ListTile(
                                                          title: Center(
                                                            child: methods.shaderMask(
                                                                methods.textOnly(
                                                                    "Take photo",
                                                                    "Leoscar",
                                                                    17.0,
                                                                    Colors
                                                                        .white,
                                                                    null,
                                                                    null,
                                                                    null),
                                                                true),
                                                          ),
                                                          onTap: () =>
                                                              _getImage(true),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      height: 10.0,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: widget.user
                                                                .getDarkMode()
                                                            ? _darkColor
                                                            : Colors.white,
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
                                                      child: InkWell(
                                                        child: ListTile(
                                                          title: Center(
                                                            child: methods.shaderMask(
                                                                methods.textOnly(
                                                                    "Cancel",
                                                                    "Leoscar",
                                                                    17.0,
                                                                    Colors
                                                                        .white,
                                                                    null,
                                                                    null,
                                                                    null),
                                                                true),
                                                          ),
                                                          onTap: () =>
                                                              Navigator.pop(
                                                                  context),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(
                                                  color: Colors.transparent,
                                                  height: _screenHeight,
                                                  width: _screenWidth,
                                                );
                                        });
                                  } else {
                                    setState(() {
                                      _confirmationMessage = true;
                                      FocusScope.of(context).unfocus();
                                    });
                                    _showSnackbar(
                                        Colors.red[400],
                                        () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          setState(() {
                                            _confirmationMessage = false;
                                          });
                                        },
                                        "Discard the change(s)",
                                        () {
                                          setState(() {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            _nameController.clear();
                                            _dobController.clear();
                                            _genderController.clear();
                                            _emailController.clear();
                                            _phoneController.clear();
                                            _heightController.clear();
                                            _weightController.clear();
                                            _confirmationMessage = false;
                                            _isEditing = false;
                                          });
                                        });
                                  }
                                },
                                heroTag: 3,
                                mini: true,
                                elevation: 10.0,
                                backgroundColor: widget.user.getDarkMode()
                                    ? (!_isEditing ? _darkColor : Colors.red)
                                    : (!_isEditing ? Colors.white : Colors.red),
                                child: !_isEditing
                                    ? methods.shaderMask(
                                        Icon(
                                          LineIcons.camera,
                                          color: Colors.white,
                                        ),
                                        true,
                                      )
                                    : Icon(
                                        FlutterIcons.cancel_mco,
                                        color: Colors.white,
                                      ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(
                                      color: widget.user.getDarkMode()
                                          ? Colors.white12
                                          : Colors.black12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 24.0,
                            ),
                            child: Visibility(
                              visible: !_confirmationMessage,
                              child: FloatingActionButton(
                                onPressed: () {
                                  if (!_isEditing) {
                                    setState(() {
                                      _isEditing = true;
                                    });
                                  } else {
                                    setState(() {
                                      _confirmationMessage = true;
                                      FocusScope.of(context).unfocus();
                                    });
                                    _showSnackbar(
                                        Colors.green,
                                        () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          setState(() {
                                            _confirmationMessage = false;
                                          });
                                        },
                                        "Apply the change(s)?",
                                        () async {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          await http.post(
                                              Uri.parse(
                                                  "https://lifemaintenanceapplication.000webhostapp.com/php/editprofile.php"),
                                              body: {
                                                "name": _nameController.text,
                                                "dob": _dobController.text,
                                                "gender":
                                                    _genderController.text,
                                                "phone": _phoneController.text,
                                                "height":
                                                    _heightController.text,
                                                "weight":
                                                    _weightController.text,
                                                "email": widget.user.getEmail(),
                                              }).then((res) {
                                            if (res.body == "success") {
                                              Future.delayed(
                                                  Duration(milliseconds: 500),
                                                  () {
                                                methods.snackbarMessage(
                                                  context,
                                                  Duration(
                                                    milliseconds: 1500,
                                                  ),
                                                  Color(0XFFB563E0),
                                                  true,
                                                  methods.textOnly(
                                                      "Profile updated successfully",
                                                      "Leoscar",
                                                      18.0,
                                                      Colors.white,
                                                      null,
                                                      null,
                                                      TextAlign.center),
                                                );
                                              });
                                              setState(() {
                                                if (_nameController
                                                    .text.isNotEmpty) {
                                                  widget.user.setName(
                                                      _nameController.text);
                                                }
                                                if (_dobController
                                                    .text.isNotEmpty) {
                                                  widget.user.setDob(
                                                      _dobController.text);
                                                }
                                                if (_genderController
                                                    .text.isNotEmpty) {
                                                  widget.user.setGender(
                                                      _genderController.text);
                                                }
                                                if (_phoneController
                                                    .text.isNotEmpty) {
                                                  widget.user.setPhone(
                                                      _phoneController.text);
                                                }
                                                if (_heightController
                                                    .text.isNotEmpty) {
                                                  widget.user.setHeight(
                                                      _heightController.text);
                                                }
                                                if (_weightController
                                                    .text.isNotEmpty) {
                                                  widget.user.setWeight(
                                                      _weightController.text);
                                                }
                                                _nameController.clear();
                                                _dobController.clear();
                                                _genderController.clear();
                                                _emailController.clear();
                                                _phoneController.clear();
                                                _heightController.clear();
                                                _weightController.clear();
                                                _confirmationMessage = false;
                                                _isEditing = false;
                                              });
                                            } else {
                                              Future.delayed(
                                                  Duration(milliseconds: 500),
                                                  () {
                                                methods.snackbarMessage(
                                                  context,
                                                  Duration(
                                                    seconds: 1,
                                                  ),
                                                  Colors.red[400],
                                                  true,
                                                  methods.textOnly(
                                                      "Fail to update profile...Please try again",
                                                      "Leoscar",
                                                      18.0,
                                                      Colors.white,
                                                      null,
                                                      null,
                                                      TextAlign.center),
                                                );
                                              });
                                              setState(() {
                                                _confirmationMessage = false;
                                                _isEditing = true;
                                              });
                                            }
                                          });
                                        });
                                  }
                                },
                                heroTag: 4,
                                mini: true,
                                elevation: 10.0,
                                backgroundColor: widget.user.getDarkMode()
                                    ? (!_isEditing ? _darkColor : Colors.green)
                                    : (!_isEditing
                                        ? Colors.white
                                        : Colors.green),
                                child: !_isEditing
                                    ? methods.shaderMask(
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 4.0,
                                          ),
                                          child: Icon(
                                            FlutterIcons.edit_faw,
                                            color: Colors.white,
                                          ),
                                        ),
                                        true,
                                      )
                                    : Icon(
                                        FlutterIcons.save_faw,
                                        color: Colors.white,
                                      ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(
                                      color: widget.user.getDarkMode()
                                          ? Colors.white12
                                          : Colors.black12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      _information(
                          "Name", widget.user.getName(), 0, _nameController),
                      _information("Date of Birth", widget.user.getDob(), 1,
                          _dobController),
                      _information("Gender", widget.user.getGender(), 2,
                          _genderController),
                      _information(
                          "Phone", widget.user.getPhone(), 3, _phoneController),
                      _information("Height", widget.user.getHeight() + " cm", 4,
                          _heightController),
                      _information("Weight", widget.user.getWeight() + " kg", 5,
                          _weightController),
                      Visibility(
                        visible: !_isEditing,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30.0,
                            ),
                            _information("Logout", "", 6, null),
                            _information("Feedback", "", 7, null),
                            SizedBox(
                              height: 30.0,
                            ),
                            _information(
                                "Change Email", "", 8, _emailController),
                            _information("Change Password", "", 9, null),
                            _information("Delete Account", "", 10, null),
                            SizedBox(
                              height: 30.0,
                            ),
                            _information(
                                widget.user.getDarkMode()
                                    ? "Light Mode"
                                    : "Dark Mode",
                                "",
                                11,
                                null),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _gif,
                scale: 2,
              ),
            ),
          );
  }

  Widget _information(String _leading, String _content, int _index,
      TextEditingController _textEditingController) {
    Color _color;
    Widget _icon;
    if (_index % 5 == 0) {
      _color = Color(0XFF015F9F);
    } else if (_index % 5 == 1) {
      _color = Color(0XFF00D1D0);
    } else if (_index % 5 == 2) {
      _color = Color(0XFF00CC49);
    } else if (_index % 5 == 3) {
      _color = Color(0XFFFA9308);
    } else {
      _color = Color(0XFFEE1F27);
    }
    if (_index == 0) {
      _icon = Icon(
        FlutterIcons.address_card_o_faw,
        color: _color,
      );
    } else if (_index == 1) {
      _icon = Icon(
        FlutterIcons.birthday_cake_faw,
        color: _color,
      );
    } else if (_index == 2) {
      _icon = Icon(
        FlutterIcons.transgender_faw,
        color: _color,
      );
    } else if (_index == 3) {
      _icon = Icon(
        FlutterIcons.mobile1_ant,
        color: _color,
      );
    } else if (_index == 4) {
      _icon = Icon(
        FlutterIcons.human_male_height_mco,
        color: _color,
      );
    } else if (_index == 5) {
      _icon = Icon(
        FlutterIcons.weight_kilogram_mco,
        color: _color,
      );
    } else if (_index == 6) {
      _icon = Icon(
        FlutterIcons.logout_variant_mco,
        color: _color,
      );
    } else if (_index == 7) {
      _icon = Icon(
        FlutterIcons.comment_discussion_oct,
        color: _color,
      );
    } else if (_index == 8) {
      _icon = Icon(
        FlutterIcons.email_outline_mco,
        color: _color,
        size: 26.0,
      );
    } else if (_index == 9) {
      _icon = Icon(
        FlutterIcons.lock_sli,
        color: _color,
      );
    } else if (_index == 10) {
      _color = Colors.red[400];
      _icon = Icon(
        FlutterIcons.deleteuser_ant,
        color: Colors.white,
      );
    } else if (_index == 11) {
      _color = widget.user.getDarkMode()
          ? Colors.white.withOpacity(0.8)
          : _darkColor;
      _icon = Icon(
        FlutterIcons.theme_light_dark_mco,
        color: widget.user.getDarkMode() ? _darkColor : Colors.white,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 5.0,
      ),
      child: Container(
        height: 60.0,
        child: Card(
          color: _index == 10 || _index == 11 ? _color : null,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            side: BorderSide(
              width: 1.5,
              color: _index != 10 || _index != 11 ? _color : Colors.black12,
            ),
          ),
          child: _index <= 5
              ? _personalContent(_index, _leading, _content, _color, _icon,
                  _textEditingController)
              : _otherContent(_index, _leading, _content, _color, _icon),
        ),
      ),
    );
  }

  Widget _personalContent(
      int _index,
      String _leading,
      String _content,
      Color _color,
      Widget _widget,
      TextEditingController _textEditingController) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              _widget,
              Padding(
                padding: const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child: methods.textOnly(
                    _leading,
                    "Leoscar",
                    18.0,
                    widget.user.getDarkMode() &&
                            (_content == "0.0 kg" || _content == "0.0 cm")
                        ? Colors.red
                        : widget.user.getDarkMode()
                            ? Colors.white70
                            : (_content == "0.0 kg" || _content == "0.0 cm")
                                ? Colors.red
                                : Colors.black,
                    FontWeight.normal,
                    FontStyle.normal,
                    TextAlign.start),
              ),
            ],
          ),
          !_isEditing
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                  ),
                  child: methods.textOnly(
                      _content,
                      "Leoscar",
                      18.0,
                      widget.user.getDarkMode() &&
                              (_content == "0.0 kg" || _content == "0.0 cm")
                          ? Colors.red
                          : widget.user.getDarkMode()
                              ? Colors.white70
                              : (_content == "0.0 kg" || _content == "0.0 cm")
                                  ? Colors.red
                                  : Colors.black,
                      FontWeight.normal,
                      FontStyle.normal,
                      TextAlign.start),
                )
              : Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 2.5,
                    ),
                    child: _editContent(
                        _index, _content, _color, _textEditingController),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _editContent(int _index, String _content, Color _color,
      TextEditingController _textEditingController) {
    return Stack(
      children: [
        TextFormField(
          onTap: () {
            if (_index == 1) {
              DatePicker.showDatePicker(
                context,
                minTime: DateTime(DateTime.now().year - 100, 1, 1),
                maxTime: DateTime.now(),
                theme: DatePickerTheme(
                  cancelStyle: TextStyle(
                    fontFamily: "Leoscar",
                    fontSize: 17.0,
                    color: Colors.grey,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold,
                  ),
                  doneStyle: TextStyle(
                    fontFamily: "Leoscar",
                    fontSize: 17.0,
                    color: Color(0XFF9866B3),
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold,
                  ),
                  itemStyle: TextStyle(
                    fontFamily: "Leoscar",
                    fontSize: 17.0,
                    letterSpacing: 1.0,
                  ),
                ),
                onCancel: () {
                  setState(() {
                    if (_dobController.text == " ") {
                      _dobController.clear();
                    }
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                onConfirm: (date) {
                  setState(() {
                    _dobController.text = DateFormat("yyyy-MM-dd").format(date);
                  });
                },
                currentTime: DateTime.parse(widget.user.getDob()),
              );
            } else if (_index == 4) {
              _showNumberPicker(_index);
            } else if (_index == 5) {
              _showNumberPicker(_index);
            }
          },
          controller: _textEditingController,
          keyboardType: _index == 3 ? TextInputType.number : TextInputType.name,
          inputFormatters: _index == 3
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ]
              : [],
          cursorColor: _color,
          readOnly: _index == 0 || _index == 2 || _index == 3 ? false : true,
          style: TextStyle(
            fontFamily: "Leoscar",
            fontSize: 18.0,
            letterSpacing: 1.0,
          ),
          textAlign: TextAlign.end,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: _content,
            hintStyle: TextStyle(
              fontFamily: "Leoscar",
              fontSize: 18.0,
              letterSpacing: 1.0,
              color: Colors.black38,
            ),
          ),
        ),
        (_index == 2)
            ? Container(
                height: 60.0,
                width: double.infinity,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: SizedBox.shrink(),
                    items: ["Male", "Female"]
                        .map((label) => DropdownMenuItem(
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontFamily: "Leoscar",
                                  fontSize: 17.0,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              value: label,
                            ))
                        .toList(),
                    onChanged: (_gender) {
                      setState(() {
                        _genderController.text = _gender;
                      });
                    },
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget _otherContent(int _index, String _leading, String _content,
      Color _color, Widget _widget) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: _index != 10 ? _color.withOpacity(0.3) : Colors.red[200],
      onTap: () {
        if (_index == 6) {
          return showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              builder: (BuildContext context) {
                return SliderButton(
                  alignLabel: Alignment.center,
                  swipeFromRight: false,
                  label: methods.textOnly(" Slide to logout", "Leoscar", 18.0,
                      Colors.white, null, null, TextAlign.center),
                  icon: Icon(
                    FlutterIcons.logout_variant_mco,
                    color: Colors.white,
                  ),
                  width: _screenWidth,
                  radius: 8,
                  buttonColor: widget.user.getDarkMode()
                      ? _darkColor
                      : Color(0XFFB563E0),
                  backgroundColor: widget.user.getDarkMode()
                      ? Color(0XFF9E9E9E)
                      : Colors.white,
                  highlightedColor:
                      widget.user.getDarkMode() ? _darkColor : Colors.white,
                  baseColor: widget.user.getDarkMode()
                      ? Colors.white
                      : Color(0XFFB563E0),
                  dismissThresholds: 0.5,
                  action: () {},
                  onDismissed: (dir) {
                    Navigator.pop(context);
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: LoginScreen(userLogout: 2),
                          type: PageTransitionType.fade,
                        ),
                      );
                    });
                  },
                );
              });
        } else if (_index == 7) {
          Navigator.push(
            context,
            PageTransition(
              child: EditProfile(1, widget.user),
              type: PageTransitionType.fade,
            ),
          );
        } else if (_index == 8) {
          Navigator.push(
            context,
            PageTransition(
              child: EditProfile(2, widget.user),
              type: PageTransitionType.fade,
            ),
          );
        } else if (_index == 9) {
          Navigator.push(
            context,
            PageTransition(
              child: EditProfile(4, widget.user),
              type: PageTransitionType.fade,
            ),
          );
        } else if (_index == 10) {
          Navigator.push(
            context,
            PageTransition(
              child: EditProfile(6, widget.user),
              type: PageTransitionType.fade,
            ),
          );
        } else if (_index == 11) {
          return showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              builder: (BuildContext context) {
                return SliderButton(
                  swipeFromRight: widget.user.getDarkMode(),
                  alignLabel: Alignment.center,
                  label: methods.textOnly(
                      widget.user.getDarkMode()
                          ? "Slide to change to light mode"
                          : " Slide to change to dark mode",
                      "Leoscar",
                      18.0,
                      Colors.white,
                      null,
                      null,
                      TextAlign.center),
                  icon: Icon(
                    FlutterIcons.theme_light_dark_mco,
                    color: widget.user.getDarkMode()
                        ? Color(0XFF424242)
                        : Colors.white,
                  ),
                  width: _screenWidth,
                  radius: 8,
                  buttonColor:
                      widget.user.getDarkMode() ? Colors.white : _darkColor,
                  backgroundColor: widget.user.getDarkMode()
                      ? Colors.white.withOpacity(0.8)
                      : _darkColor.withOpacity(0.5),
                  highlightedColor:
                      widget.user.getDarkMode() ? Colors.white : _darkColor,
                  baseColor:
                      widget.user.getDarkMode() ? _darkColor : Colors.white,
                  dismissThresholds: 0.5,
                  action: () {},
                  onDismissed: (dir) {
                    Navigator.pop(context);
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      _savePref();
                      callback2();
                    });
                  },
                );
              });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Row(
          children: <Widget>[
            _widget,
            Padding(
              padding: const EdgeInsets.only(
                top: 4.0,
                left: 10.0,
              ),
              child: methods.textOnly(
                  _leading,
                  "Leoscar",
                  18.0,
                  _index != 10 && _index != 11
                      ? (widget.user.getDarkMode()
                          ? Colors.white70
                          : Colors.black)
                      : _index == 11 && widget.user.getDarkMode()
                          ? _darkColor
                          : Colors.white,
                  FontWeight.normal,
                  FontStyle.normal,
                  TextAlign.start),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _showSnackbar(Color color, Function() onTapCancel,
      String message, Function() onTapProceed) {
    return methods.snackbarMessage(
      context,
      Duration(days: 365),
      color,
      false,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Container(
              child: Icon(
                LineIcons.times,
                color: Colors.white,
              ),
            ),
            onTap: onTapCancel,
          ),
          methods.textOnly(message, "Leoscar", 18.0, Colors.white, null, null,
              TextAlign.center),
          GestureDetector(
            child: Container(
              child: Icon(
                LineIcons.check,
                color: Colors.white,
              ),
            ),
            onTap: onTapProceed,
          ),
        ],
      ),
    );
  }

  void _showNumberPicker(int _index) {
    setState(() {
      if (_index == 4) {
        _userNewHeight = double.parse(widget.user.getHeight());
      } else {
        _userNewWeight = double.parse(widget.user.getWeight());
      }
    });
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return _loading == false
                ? methods.shaderMask(
                    Container(
                      height: _screenHeight / 4.3,
                      child: Column(
                        children: [
                          Spacer(),
                          methods.textOnly(
                              "Please insert your " +
                                  (_index == 4 ? "height (cm)" : "weight (kg)"),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    child: Icon(
                                      LineIcons.times,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    _gif.evict();
                                    Navigator.pop(context);
                                  },
                                ),
                                DecimalNumberPicker(
                                    minValue: _index == 0 ? 50 : 30,
                                    maxValue: _index == 0 ? 200 : 300,
                                    decimalPlaces: 1,
                                    value: _index == 4
                                        ? _userNewHeight
                                        : _userNewWeight,
                                    onChanged: (value) {
                                      newSetState(() {
                                        if (_index == 4) {
                                          _userNewHeight = value;
                                          _heightController.text =
                                              value.toString();
                                        } else {
                                          _userNewWeight = value;
                                          _weightController.text =
                                              value.toString();
                                        }
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
                                    Navigator.pop(context);
                                    // newSetState(() {
                                    // });
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
                        scale: 5,
                      ),
                    ),
                  );
          });
        });
    // double _tempValue = _index == 4
    //     ? (_height != 0.0
    //         ? _height
    //         : widget.user.getHeight() == "0.0"
    //             ? 50.0
    //             : double.parse(widget.user.getHeight()))
    //     : (_weight != 0.0
    //         ? _weight
    //         : widget.user.getWeight() == "0.0"
    //             ? 30.0
    //             : double.parse(widget.user.getWeight()));
    // methods.snackbarMessage(
    //   context,
    //   Duration(days: 365),
    //   Color(0XFFB563E0),
    //   false,
    //   StatefulBuilder(builder: (context, newSetState) {
    //     return Container(
    //       height: _screenHeight / 4.5,
    //       child: Column(
    //         children: [
    //           methods.textOnly(
    //               "Please insert your " +
    //                   (_index == 4 ? "height (cm)" : "weight (kg)"),
    //               "Leoscar",
    //               18.0,
    //               Colors.white,
    //               null,
    //               null,
    //               TextAlign.center),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               GestureDetector(
    //                 child: Container(
    //                   child: Icon(
    //                     LineIcons.times,
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //                 onTap: () =>
    //                     ScaffoldMessenger.of(context).hideCurrentSnackBar(),
    //               ),
    //               DecimalNumberPicker(
    //                   minValue: _index == 0 ? 50 : 30,
    //                   maxValue: _index == 0 ? 200 : 300,
    //                   decimalPlaces: 1,
    //                   value: _tempValue,
    //                   onChanged: (value) {
    //                     newSetState(() {
    //                       _tempValue = value;
    //                     });
    //                   }),
    //               GestureDetector(
    //                 child: Container(
    //                   child: Icon(
    //                     LineIcons.check,
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //                 onTap: () {
    //                   SchedulerBinding.instance.addPostFrameCallback((_) {
    //                     ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //                     setState(() {
    //                       if (_index == 4 && _tempValue != null) {
    //                         _height = _tempValue;
    //                         _heightController.text = _tempValue.toString();
    //                       } else if (_index == 5 && _tempValue != null) {
    //                         _weight = _tempValue;
    //                         _weightController.text = _tempValue.toString();
    //                       }
    //                     });
    //                   });
    //                 },
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     );
    //   }),
    // );
  }

  Future<void> _getImage(bool isCamera) async {
    if (widget.user.getEmail() != 'Unregistered') {
      setState(() {
        _isCropping = true;
        Navigator.pop(context);
      });
      if (isCamera) {
        _pickedFile = (await ImagePicker().getImage(
            source: ImageSource.camera, maxHeight: 500.0, maxWidth: 500.0));
      } else {
        _pickedFile = (await ImagePicker().getImage(
            source: ImageSource.gallery, maxHeight: 500.0, maxWidth: 500.0));
      }

      if (_pickedFile == null) {
        setState(() {
          _isCropping = false;
        });
        return;
      } else {
        setState(() {
          _image = File(_pickedFile.path);
        });
        File _croppedFile = await ImageCropper.cropImage(
          sourcePath: _image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          maxHeight: 500,
          maxWidth: 500,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Image Cropper',
              toolbarColor: Color(0XFFB563E0),
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: Color(0XFFB563E0),
              hideBottomControls: true,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
        );
        if (_croppedFile == null) {
          setState(() {
            _isCropping = false;
          });
          return;
        } else {
          setState(() {
            _image = _croppedFile;
          });

          String base64Image = base64Encode(_image.readAsBytesSync());
          await http.post(
              Uri.parse(
                  "https://lifemaintenanceapplication.000webhostapp.com/php/updateprofilepic.php"),
              body: {
                "email": widget.user.getEmail(),
                "encoded_string": base64Image,
              }).then((res) {
            if (res.body == "success") {
              setState(() {
                DefaultCacheManager manager = new DefaultCacheManager();
                manager.removeFile(
                    "https://lifemaintenanceapplication.000webhostapp.com/images/${widget.user.getEmail()}.jpg");
                imageCache.clear();
              });
              SchedulerBinding.instance.addPostFrameCallback((_) {
                methods.snackbarMessage(
                  context,
                  Duration(
                    milliseconds: 1500,
                  ),
                  Color(0XFFB563E0),
                  true,
                  methods.textOnly("Profile updated successfully", "Leoscar",
                      18.0, Colors.white, null, null, TextAlign.center),
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
                      "Fail to update profile...Please try again",
                      "Leoscar",
                      18.0,
                      Colors.white,
                      null,
                      null,
                      TextAlign.center),
                );
              });
            }
          }).catchError((err) {
            print(err);
          });
        }
      }
    } else {
      methods.showUnregisteredDialog(context);
    }
    setState(() {
      _isCropping = false;
    });
  }

  Future<void> _savePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool darkMode = prefs.getBool('darkmode') ?? false;
    await prefs.setBool('darkmode', !darkMode);
    print("darkModepage4: ${prefs.getBool('darkmode')}");
    setState(() {
      widget.user.setDarkMode(!darkMode);
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 60);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 60);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
