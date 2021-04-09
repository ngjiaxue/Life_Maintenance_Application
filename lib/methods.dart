import 'loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Methods {
  List<Color> _color = [
    Color(0XFFFC00FF),
    Color(0XFF00DBDE),
  ];

  List<Color> color() {
    return this._color;
  }

  Widget textOnly(String text, String fontFamily, double fontSize, Color color,
      FontWeight fontWeight, FontStyle fontStyle, TextAlign textAlign) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        letterSpacing: fontFamily == "Leoscar" ? 1.0 : 0.0,
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
      ),
      textAlign: textAlign,
    );
  }

  Widget textField(
      TextInputAction textInputAction,
      FocusNode focusNode,
      TextInputType keyboardtype,
      bool obscureText,
      TextEditingController controller,
      Widget prefixIcon,
      Widget suffixIcon,
      String labelText,
      String fontFamily,
      double fontSize,
      InputBorder inputBorder) {
    return TextField(
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        letterSpacing: 1.0,
      ),
      textInputAction: textInputAction,
      focusNode: focusNode,
      keyboardType: keyboardtype,
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          letterSpacing: 1.0,
        ),
        border: inputBorder,
      ),
    );
  }

  Widget textFormField(
      Function() onTap,
      FocusNode focusNode,
      TextInputAction textInputAction,
      TextInputType keyboardType,
      bool obscureText,
      TextEditingController controller,
      String Function(String) validator,
      Widget prefixIcon,
      Widget suffixIcon,
      String labelText,
      String fontFamily,
      double fontSize,
      InputBorder inputBorder) {
    return TextFormField(
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        letterSpacing: 1.0,
      ),
      onTap: onTap,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      inputFormatters: keyboardType.toString() ==
              "TextInputType(name: TextInputType.number, signed: false, decimal: false)"
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ]
          : [],
      obscureText: obscureText,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red[400],
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red[400],
          ),
        ),
        errorStyle: TextStyle(
          fontFamily: fontFamily,
          letterSpacing: 1.0,
          color: Colors.red[400],
        ),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          letterSpacing: 1.0,
        ),
        border: inputBorder,
      ),
      readOnly: keyboardType.toString() ==
              "TextInputType(name: TextInputType.datetime, signed: null, decimal: null)"
          ? true
          : false,
    );
  }

  Future<Null> snackbarMessage(BuildContext context, Duration duration,
      Color color, bool dismissable, Widget widget) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(
          new SnackBar(
            duration: duration,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(8.0),
            //     topRight: Radius.circular(8.0),
            //   ),
            // ),
            backgroundColor: color,
            content: widget,
          ),
        )
        .closed
        .then((reason) {
      if (reason == SnackBarClosedReason.swipe && dismissable == false) {
        snackbarMessage(context, duration, color, false, widget);
      }
    });
  }

  Future<bool> backPressed(BuildContext context, FocusNode focusNode) {
    focusNode.unfocus();
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: textOnly("Exit Application?", "Leoscar", 26.0,
                Color(0XFF7100AD), FontWeight.bold, null, null),
            content: textOnly("Are you sure?", "Leoscar", 17.0, null,
                FontWeight.w500, null, null),
            actions: <Widget>[
              MaterialButton(
                highlightColor: Colors.transparent,
                splashColor: Color(0XFFE7BAFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: textOnly("Exit", "Leoscar", 18.0, Color(0XFF9866B3),
                    FontWeight.bold, null, null),
              ),
              MaterialButton(
                highlightColor: Colors.transparent,
                splashColor: Color(0XFFE7BAFF),
                color: Color(0XFF9866B3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: textOnly("Cancel", "Leoscar", 18.0, Colors.white,
                    FontWeight.bold, null, null),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
        ) ??
        false;
  }

  Widget noRecordFound(double scale, double fontSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/norecord.png",
          scale: scale,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
          ),
          child: shaderMask(
            textOnly("No record found", "Leoscar", fontSize, Colors.white,
                FontWeight.normal, FontStyle.normal, TextAlign.center),
            true,
          ),
        ),
      ],
    );
  }

  Widget appBarColor() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.deepOrange[900],
              Colors.deepOrange,
              Colors.deepOrange[300],
            ]),
      ),
    );
  }

  Widget divider() {
    return Divider(
      color: Colors.grey,
      thickness: 1.5,
    );
  }

  Widget shaderMask(Widget child, bool ascending) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: ascending ? Alignment.topCenter : Alignment.bottomCenter,
          end: ascending ? Alignment.bottomCenter : Alignment.topCenter,
          colors: color(),
          tileMode: TileMode.clamp,
        ).createShader(bounds);
      },
      child: child,
    );
  }
  // Widget statusButton(String status, bool _color, Function method) {
  //   //start statusButton method
  //   return FlatButton(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(8.0),
  //     ),
  //     onPressed: method,
  //     child: _color
  //         ? Ink(
  //             decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   colors: [
  //                     Colors.orange[200],
  //                     Colors.orange[300],
  //                     Colors.orange[400],
  //                     Colors.orange[600],
  //                     Colors.orange[700],
  //                   ],
  //                   begin: Alignment.topLeft,
  //                   end: Alignment.bottomRight,
  //                 ),
  //                 borderRadius: BorderRadius.circular(8.0)),
  //             child: Container(
  //               padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
  //               child: textOnly(
  //                   status, "Oxanium Regular", 20.0, null, null, null, null),
  //             ),
  //           )
  //         : textOnly(status, "Oxanium Regular", 20.0, null, null, null, null),
  //   );
  // } //end statusButton method

  Widget pendingOrDeliveringOrDelivered(String status) {
    //start _pendingOrDeliveringOrDelivered method
    if (status == "Pending") {
      return detailsShow(
          status, Colors.yellow[300]); //call _detailsShow method when Pending
    } else if (status == "Delivering") {
      return detailsShow(status,
          Colors.orange[200]); //call _detailsShow method when Delivering
    } else {
      return detailsShow(
          status, Colors.green[400]); //call _detailsShow method when Delivered
    }
  } //end _pendingOrDeliveringOrDelivered method

  Widget detailsShow(String status, Color color) {
    //start _detailsShow method
    return Padding(
      padding: const EdgeInsets.only(left: 230.0, right: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          color: color,
        ),
        child: Align(
          alignment: Alignment.center,
          child:
              textOnly(status, "Oxanium Regular", 20.0, null, null, null, null),
        ),
      ),
    );
  } //end _detailsShow method

  Future<bool> showUnregisteredDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        content: Text(
          "Please login or sign up to continue!",
          textAlign: TextAlign.justify,
          style: TextStyle(fontFamily: "Oxanium Regular", fontSize: 18.0),
        ),
        actions: <Widget>[
          new TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                (states) => Color(0XFFE7BAFF),
              ),
              shape: MaterialStateProperty.resolveWith(
                (states) => RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            child: textOnly("Login", "Oxanium Regular", 18.0, Colors.orange,
                FontWeight.bold, FontStyle.normal, TextAlign.center),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen(userLogout: 1),
                ),
              );
            },
          ),
          new TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                (states) => Color(0XFF9866B3),
              ),
              overlayColor: MaterialStateColor.resolveWith(
                (states) => Color(0XFFE7BAFF),
              ),
              shape: MaterialStateProperty.resolveWith(
                (states) => RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            child: textOnly("Sign Up", "Oxanium Regular", 18.0, Colors.orange,
                FontWeight.bold, FontStyle.normal, TextAlign.center),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen(userLogout: 4),
                ),
              );
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
      ),
    );
  }
}
