import 'tabs.dart';
import 'user.dart';
import 'methods.dart';
import 'fadeanimation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

void main() => runApp(LoginScreen(1));

class LoginScreen extends StatefulWidget {
  final int userLogout; //1 = do ntg, 2 = clear password & remember me
  LoginScreen(this.userLogout);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
  User user;
  int _i = 0; //to let the animation text stop
  int _buttonClicked =
      0; //0 = login, 1 = forget password, 2 = resend verification email, 3 = sign up
  double _screenHeight;
  bool _loginPressed = true;
  Methods methods = new Methods();
  var _loginKey = GlobalKey<FormState>();

  //used by loginscreen
  bool _isChecked = false;
  bool _passwordHidden = true;
  bool _passwordHidden1 = true;
  bool _passwordHidden2 = true;
  List<bool> _informationValidate = [false, false, false];
  bool _informationValidate1 = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _passwordFocus = new FocusNode();
  TextEditingController _resetPasswordController = TextEditingController();
  FocusNode _resetPasswordFocus = new FocusNode();

  //used by signupscreen
  bool _isChecked1 = false;
  bool _passwordHidden3 = true;
  bool _passwordHidden4 = true;
  List<bool> _informationValidate2 = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  TextEditingController _nameController1 = new TextEditingController();
  TextEditingController _dobController = new TextEditingController();
  TextEditingController _genderController = new TextEditingController();
  FocusNode _genderFocus = new FocusNode();
  TextEditingController _emailController1 = new TextEditingController();
  TextEditingController _phoneController1 = new TextEditingController();
  TextEditingController _passwordController1 = new TextEditingController();
  FocusNode _passwordFocus1 = new FocusNode();
  TextEditingController _retypePasswordController1 =
      new TextEditingController();
  FocusNode _retypePasswordFocus1 = new FocusNode();

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onShow: () {
        setState(() {
          _i++;
        });
      },
    );
    if (widget.userLogout == 3) {
      _savePref(3);
    } else if (widget.userLogout == 4) {
      _loginPressed = false;
    }
    _loadPref(); //call _loadPref method
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          if (_loginPressed) {
            setState(() {
              _i++;
            });
          }
        },
        //to prevent when user misclick back button
        child: WillPopScope(
          onWillPop: () {
            return methods.backPressed(context, FocusScope.of(context));
          },
          child: Theme(
            data: ThemeData(
              primarySwatch: MaterialColor(0XFF9866B3, _swatch),
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: Color(0XFF9866B3),
              ),
            ),
            child: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  Hero(
                    tag: "background",
                    child: Image.asset(
                      "assets/images/splashbg.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  _card(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //start card method
  Widget _card() {
    return FadeAnimation(
      0.8,
      true,
      Container(
        height: _screenHeight / 1.18,
        margin: EdgeInsets.only(
          top: _screenHeight / 7,
          left: 5.0,
          right: 5.0,
        ),
        //decide whether to show login card or sign up card
        child: _loginPressed ? _loginCard() : _signUpCard(),
      ),
    );
  } //end card method

  //start login and sign up navigator
  Widget _navigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        //start Login text
        GestureDetector(
          onTap: () {
            if (!_loginPressed) {
              setState(() {
                _i++;
                _loginPressed = true;
                _isChecked1 = false;
                _passwordHidden3 = true;
                _passwordHidden4 = true;
                _buttonClicked = 0;
              });
            } else {
              setState(() {
                _i++;
              });
            }
          },
          child: methods.textOnly(
              "Login",
              "Leoscar",
              _loginPressed ? 30.0 : 25.0,
              _loginPressed ? Color(0XFF933FBF) : Colors.black45,
              _loginPressed ? FontWeight.bold : FontWeight.normal,
              FontStyle.normal,
              TextAlign.start),
        ), //end Login text
        //start Sign Up navigator
        GestureDetector(
          onTap: () {
            setState(() {
              if (_loginPressed) {
                _i++;
                _loginPressed = false;
                _passwordHidden = true;
                _passwordHidden1 = true;
                _passwordHidden2 = true;
                _buttonClicked = 3;
              }
            });
          },
          child: methods.textOnly(
              "Sign Up",
              "Leoscar",
              !_loginPressed ? 30.0 : 25.0,
              !_loginPressed ? Color(0XFF933FBF) : Colors.black45,
              !_loginPressed ? FontWeight.bold : FontWeight.normal,
              FontStyle.normal,
              TextAlign.start),
        ), //end Sign Up navigator
      ],
    );
  } //end login and sign up navigator

//start floating button
  Widget _floatingButton() {
    return FadeAnimation(
      _loginPressed ? (_i == 0 ? 1.5 : 1) : 1,
      true,
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(
            top: _loginPressed ? 25.0 : 30,
            right: 23.0,
            bottom: 20.0,
          ),
          child: SizedBox(
            width: 80.0,
            height: 80.0,
            child: FloatingActionButton(
              splashColor: Color(0XFFE7BAFF),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0XFFF2D9FF),
                        Color(0XFFE7BAFF),
                        Color(0XFFD09AED),
                        Color(0XFFBE78E3),
                        Color(0XFFAB46E0),
                        Color(0XFF7100AD),
                        Color(0XFF7D00BF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(80.0)),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300.0, minHeight: 35.0),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward,
                    size: 30.0,
                  ),
                ),
              ),
              onPressed: () {
                if (_loginPressed) {
                  setState(() {
                    _i++;
                  });
                  _login();
                } else {
                  _signUp();
                }
              },
            ),
          ),
        ),
      ),
    );
  } //end floating button

  //start login card
  Widget _loginCard() {
    return Card(
      shadowColor: Colors.deepPurple[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        side: BorderSide(
          width: 1.5,
          color: Color(0XFF360052),
        ),
      ),
      color: Colors.white,
      elevation: 20.0,
      child: Column(
        children: [
          //start Login and Sign Up navigator
          Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
            ),
            child: _navigator(),
          ), //end Login and SignUp navigator
          //make widget after Login and Sign Up navigator scrollable
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 120.0,
                    child: Hero(
                      tag: "logo",
                      child: Image.asset(
                        "assets/images/logo.png",
                        scale: 4,
                      ),
                    ),
                  ),
                  //start YOUR HEALTH IS OUR DUTY text
                  FadeAnimation(
                    _i == 0 ? 1.5 : 0.8,
                    true,
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        left: 20.0,
                        bottom: 10.0,
                      ),
                      child: _i == 0
                          ? FutureBuilder(
                              future: Future.delayed(
                                Duration(milliseconds: 1500),
                              ),
                              builder: (c, s) => s.connectionState ==
                                      ConnectionState.done
                                  ? AnimatedTextKit(
                                      // displayFullTextOnTap: true,
                                      isRepeatingAnimation: false,
                                      animatedTexts: [
                                        TypewriterAnimatedText(
                                          "YOUR HEALTH\nIS OUR DUTY",
                                          textStyle: TextStyle(
                                            fontFamily: "Kultur",
                                            fontSize: 35.0,
                                            color: Color(0XFF3E005E),
                                          ),
                                          speed: Duration(milliseconds: 100),
                                        )
                                      ],
                                    )
                                  : Text(" "),
                            )
                          : methods.textOnly(
                              "YOUR HEALTH\nIS OUR DUTY",
                              "Kultur",
                              35.0,
                              Color(0XFF3E005E),
                              FontWeight.normal,
                              FontStyle.normal,
                              TextAlign.start),
                    ),
                  ), //end YOUR HEALTH IS OUR DUTY text
                  //start email & password textfield
                  //start email textfield
                  FadeAnimation(
                    _i == 0 ? 1.5 : 1,
                    true,
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: methods.textField(
                        TextInputAction.next,
                        null,
                        TextInputType.emailAddress,
                        false,
                        _emailController,
                        Icon(
                          FlutterIcons.email_outline_mco,
                        ),
                        null,
                        "Email",
                        "Leoscar",
                        17.0,
                        OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ), //end email textfield
                  //start password textfield
                  FadeAnimation(
                    _i == 0 ? 1.5 : 1,
                    true,
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: methods.textField(
                        TextInputAction.done,
                        _passwordFocus,
                        TextInputType.text,
                        _passwordHidden,
                        _passwordController,
                        Icon(
                          FlutterIcons.lock_sli,
                          size: 22.0,
                        ),
                        IconButton(
                          icon: Icon(
                            _passwordHidden
                                ? LineIcons.eyeSlash
                                : LineIcons.eye,
                          ),
                          onPressed: () async {
                            if (!_passwordFocus.hasPrimaryFocus) {
                              _passwordFocus.unfocus();
                              _passwordFocus.canRequestFocus = false;
                            }
                            setState(() {
                              _passwordHidden = !_passwordHidden;
                            });
                          },
                        ),
                        "Password",
                        "Leoscar",
                        17.0,
                        OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ), //end password textfield
                  //end email & password textfield
                  //start remember me
                  FadeAnimation(
                    _i == 0 ? 1.5 : 1,
                    true,
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.grey[400],
                            ),
                            child: Checkbox(
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(4.0),
                              // ),
                              value: _isChecked,
                              activeColor: Color(0XFF933FBF),
                              onChanged: (bool value) {
                                _onTick(value); //call _onTick method
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                            ),
                            child: methods.textOnly(
                                "Remember Me",
                                "Leoscar",
                                15.0,
                                Colors.black,
                                FontWeight.normal,
                                FontStyle.normal,
                                TextAlign.start),
                          ),
                        ],
                      ),
                    ),
                  ), //end remember me
                  //start forget password
                  FadeAnimation(
                    _i == 0 ? 1.5 : 1,
                    true,
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        left: 20.0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _i++;
                            _buttonClicked = 1;
                          });
                          _forgetPassword(); //call _forgetPassword method
                        },
                        child: methods.textOnly(
                            "Forget Password?",
                            "Leoscar",
                            18.0,
                            Color(0XFF7100AD),
                            FontWeight.normal,
                            FontStyle.italic,
                            TextAlign.start),
                      ),
                    ),
                  ), //end forget password
                  //start resend verification email
                  FadeAnimation(
                    _i == 0 ? 1.5 : 1,
                    true,
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        left: 20.0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _i++;
                            _buttonClicked = 2;
                          });
                          _resendVerificationEmail(); //call _resendVerificationEmail method
                        },
                        child: methods.textOnly(
                            "Resend Verification Email?",
                            "Leoscar",
                            18.0,
                            Color(0XFF7100AD),
                            FontWeight.normal,
                            FontStyle.italic,
                            TextAlign.start),
                      ),
                    ),
                  ), //end resend verification email
                  _floatingButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  } //end login card

  //start sign up card
  Widget _signUpCard() {
    return Card(
      shadowColor: Colors.deepPurple[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        side: BorderSide(
          width: 1.5,
          color: Color(0XFF360052),
        ),
      ),
      color: Colors.white,
      elevation: 20.0,
      child: Column(
        children: [
          //start Login and Sign Up navigator
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: _navigator(),
          ), //end Login and SignUp navigator
          //make widget after Login and Sign Up navigator scrollable
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _loginKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // start name to retype password textformfield
                    //start name textformfield
                    FadeAnimation(
                      1,
                      true,
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: methods.textFormField(
                            null,
                            null,
                            TextInputAction.done,
                            TextInputType.name,
                            false,
                            _nameController1,
                            _validateName,
                            Icon(
                              FlutterIcons.address_card_o_faw,
                              size: 22.0,
                            ),
                            null,
                            "Name",
                            "Leoscar",
                            17.0,
                            null),
                      ),
                    ), //end name textformfield
                    //start DOB textformfield
                    FadeAnimation(
                      1,
                      true,
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: methods.textFormField(() {
                          if (_dobController.text.isEmpty) {
                            setState(() {
                              _dobController.text = " ";
                            });
                          }
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
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              });
                            },
                            onConfirm: (date) {
                              setState(() {
                                _dobController.text =
                                    DateFormat("yyyy-MM-dd").format(date);
                              });
                            },
                            currentTime: _dobController.text == " "
                                ? DateTime.now()
                                : DateTime.parse(_dobController.text),
                          );
                        },
                            null,
                            TextInputAction.done,
                            TextInputType.datetime,
                            false,
                            _dobController,
                            _validateDOB,
                            Icon(
                              FlutterIcons.birthday_cake_faw,
                              size: 22.0,
                            ),
                            null,
                            "Date of Birth",
                            "Leoscar",
                            17.0,
                            null),
                      ),
                    ), //end DOB textformfield
                    //start gender textformfield
                    FadeAnimation(
                      1,
                      true,
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: Stack(
                          children: [
                            methods.textFormField(
                                () => setState(() {
                                      _genderFocus.requestFocus();
                                    }),
                                _genderFocus,
                                TextInputAction.done,
                                TextInputType.datetime,
                                false,
                                _genderController,
                                _validateGender,
                                Icon(
                                  FlutterIcons.transgender_faw,
                                  size: 22.0,
                                ),
                                null,
                                "Gender",
                                "Leoscar",
                                17.0,
                                null),
                            Container(
                              height: 60.0,
                              width: double.infinity,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  icon: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      right: 5.0,
                                    ),
                                    child: Icon(
                                      FlutterIcons.chevron_small_down_ent,
                                      color: _genderFocus.hasFocus
                                          ? Color(0XFF9866B3)
                                          : Colors.black45,
                                    ),
                                  ),
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
                                      _genderFocus.requestFocus();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ), //end gender textformfield
                    //start email textformfield
                    FadeAnimation(
                      1,
                      true,
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: methods.textFormField(
                            null,
                            null,
                            TextInputAction.next,
                            TextInputType.emailAddress,
                            false,
                            _emailController1,
                            _validateEmail,
                            Icon(
                              FlutterIcons.email_outline_mco,
                            ),
                            null,
                            "Email",
                            "Leoscar",
                            17.0,
                            null),
                      ),
                    ), //end email textformfield
                    //start phone textformfield
                    FadeAnimation(
                      1,
                      true,
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: methods.textFormField(
                            null,
                            null,
                            TextInputAction.next,
                            TextInputType.number,
                            false,
                            _phoneController1,
                            _validatePhone,
                            Icon(
                              FlutterIcons.mobile1_ant,
                              size: 22.0,
                            ),
                            null,
                            "Phone",
                            "Leoscar",
                            17.0,
                            null),
                      ),
                    ), //end phone textformfield
                    //start password textformfield
                    FadeAnimation(
                      1,
                      true,
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: "Leoscar",
                            fontSize: 17.0,
                            letterSpacing: 1.0,
                          ),
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context)
                                .requestFocus(_retypePasswordFocus1);
                          },
                          focusNode: _passwordFocus1,
                          obscureText: _passwordHidden3,
                          controller: _passwordController1,
                          validator: _validatePassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              FlutterIcons.lock_sli,
                              size: 22.0,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordHidden3
                                    ? LineIcons.eyeSlash
                                    : LineIcons.eye,
                              ),
                              onPressed: () async {
                                if (!_passwordFocus1.hasPrimaryFocus) {
                                  _passwordFocus1.unfocus();
                                  _passwordFocus1.canRequestFocus = false;
                                }
                                setState(() {
                                  _passwordHidden3 = !_passwordHidden3;
                                });
                              },
                            ),
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
                              fontFamily: "Leoscar",
                              letterSpacing: 1.0,
                              color: Colors.red[400],
                            ),
                            labelText: "Password",
                            labelStyle: TextStyle(
                              fontFamily: "Leoscar",
                              fontSize: 17.0,
                              color: Colors.black54,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ), //end password textformfield
                    //start retype password textformfield
                    FadeAnimation(
                      1,
                      true,
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: methods.textFormField(
                            null,
                            _retypePasswordFocus1,
                            TextInputAction.done,
                            TextInputType.text,
                            _passwordHidden4,
                            _retypePasswordController1,
                            _validateRetypePassword,
                            Icon(
                              FlutterIcons.lock_sli,
                              size: 22.0,
                            ),
                            IconButton(
                              icon: Icon(
                                _passwordHidden4
                                    ? LineIcons.eyeSlash
                                    : LineIcons.eye,
                              ),
                              onPressed: () async {
                                if (!_retypePasswordFocus1.hasPrimaryFocus) {
                                  _retypePasswordFocus1.unfocus();
                                  _retypePasswordFocus1.canRequestFocus = false;
                                }
                                setState(() {
                                  _passwordHidden4 = !_passwordHidden4;
                                });
                              },
                            ),
                            "Re-type Password",
                            "Leoscar",
                            17.0,
                            null),
                      ),
                    ), //end retype password textformfield
                    //end name to retype password textformfield
                    //start EULA
                    FadeAnimation(
                      1,
                      true,
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Theme(
                              data: ThemeData(
                                unselectedWidgetColor: Colors.grey[400],
                              ),
                              child: Checkbox(
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(4.0),
                                // ),
                                value: _isChecked1,
                                activeColor: Color(0XFF933FBF),
                                onChanged: (bool value) {
                                  setState(() {
                                    _isChecked1 = value;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 3.0,
                              ),
                              child: methods.textOnly(
                                  "I accept the terms in the ",
                                  "Leoscar",
                                  13.0,
                                  Colors.black,
                                  FontWeight.normal,
                                  FontStyle.normal,
                                  TextAlign.start),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 3.0,
                              ),
                              child: InkWell(
                                onTap: _showEULA, //call _showEULA method
                                child: Text(
                                  "License Agreement",
                                  style: TextStyle(
                                      color: Color(0XFF7100AD),
                                      fontFamily: "Leoscar",
                                      fontSize: 13.0,
                                      letterSpacing: 1.0,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ), //end EULA
                    _floatingButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  } //end sign up card

  //start _savePref method
  void _savePref(int value) async {
    String email = _emailController.text;
    String password = _passwordController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == 1) {
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
    } else if (value == 2) {
      await prefs.setString('email', email);
      await prefs.setString('pass', '');
      setState(() {
        _emailController.text = email;
        _passwordController.text = '';
        _isChecked = false;
      });
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
    }
  } //end _savePref method

  //start _loadPref method
  Future<void> _loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (widget.userLogout == 1 && email.length > 1) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        if (_passwordController.text.isNotEmpty) {
          _isChecked = true;
        } else {
          _isChecked = false;
        }
      });
    } else if (widget.userLogout == 2) {
      setState(() {
        _emailController.text = email;
        _savePref(2);
      });
    } else {
      setState(() {
        prefs.setString('email', '');
        prefs.setString('pass', '');
        _emailController.clear();
        _passwordController.clear();
      });
    }
  } //end _loadPref method

//start _onTick method
  void _onTick(bool value) {
    setState(() {
      _i++;
      _isChecked = value;
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        if (_isChecked) {
          methods.snackbarMessage(
            context,
            Duration(
              milliseconds: 500,
            ),
            Color(0XFFB563E0),
            methods.textOnly("Email & password saved", "Leoscar", 18.0,
                Colors.white, null, null, TextAlign.center),
          );
        } else {
          methods.snackbarMessage(
            context,
            Duration(
              milliseconds: 500,
            ),
            Color(0XFFB563E0),
            methods.textOnly("Email & password removed", "Leoscar", 18.0,
                Colors.white, null, null, TextAlign.center),
          );
        }
      } else {
        _isChecked = false;
        methods.snackbarMessage(
          context,
          Duration(
            seconds: 1,
          ),
          Colors.red[400],
          methods.textOnly("Please fill in all the blank(s)", "Leoscar", 18.0,
              Colors.white, null, null, TextAlign.center),
        );
      }
    });
  } //end _onTick method

  //start _forgetPassword method
  void _forgetPassword() {
    _resetPasswordController.clear();
    _passwordHidden1 = true;
    _passwordHidden2 = true;
    TextEditingController _forgetPasswordEmailController =
        TextEditingController();
    TextEditingController _retypeResetPasswordController =
        TextEditingController();
    FocusNode _retypeResetPasswordFocus = new FocusNode();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: StatefulBuilder(builder: (context, newSetState) {
            return Theme(
              data: ThemeData(
                primarySwatch: MaterialColor(0XFF9866B3, _swatch),
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Color(0XFF9866B3),
                ),
              ),
              child: AlertDialog(
                title: methods.textOnly(
                    "Forgot Password?",
                    "Leoscar",
                    26.0,
                    Color(0XFF7100AD),
                    FontWeight.bold,
                    FontStyle.normal,
                    TextAlign.start),
                content: new Container(
                  child: SingleChildScrollView(
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: <Widget>[
                          methods.textFormField(
                              null,
                              null,
                              TextInputAction.next,
                              TextInputType.emailAddress,
                              false,
                              _forgetPasswordEmailController,
                              _validateEmail,
                              Icon(
                                FlutterIcons.email_outline_mco,
                                size: 22.0,
                              ),
                              null,
                              "Email",
                              "Leoscar",
                              17.0,
                              null),
                          TextFormField(
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context)
                                  .requestFocus(_retypeResetPasswordFocus);
                            },
                            focusNode: _resetPasswordFocus,
                            obscureText: _passwordHidden1,
                            controller: _resetPasswordController,
                            validator: _validatePassword,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                FlutterIcons.lock_sli,
                                size: 22.0,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordHidden1
                                      ? LineIcons.eyeSlash
                                      : LineIcons.eye,
                                ),
                                onPressed: () async {
                                  if (!_resetPasswordFocus.hasPrimaryFocus) {
                                    _resetPasswordFocus.unfocus();
                                    _resetPasswordFocus.canRequestFocus = false;
                                  }
                                  newSetState(() {
                                    _passwordHidden1 = !_passwordHidden1;
                                  });
                                },
                              ),
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
                                fontFamily: "Leoscar",
                                letterSpacing: 1.0,
                                color: Colors.red[400],
                              ),
                              labelText: "New Password",
                              labelStyle: TextStyle(
                                fontFamily: "Leoscar",
                                fontSize: 17.0,
                                color: Colors.black54,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          methods.textFormField(
                              null,
                              _retypeResetPasswordFocus,
                              TextInputAction.done,
                              TextInputType.text,
                              _passwordHidden2,
                              _retypeResetPasswordController,
                              _validateRetypePassword,
                              Icon(
                                FlutterIcons.lock_sli,
                                size: 22.0,
                              ),
                              IconButton(
                                icon: Icon(
                                  _passwordHidden2
                                      ? LineIcons.eyeSlash
                                      : LineIcons.eye,
                                ),
                                onPressed: () async {
                                  if (!_retypeResetPasswordFocus
                                      .hasPrimaryFocus) {
                                    _retypeResetPasswordFocus.unfocus();
                                    _retypeResetPasswordFocus.canRequestFocus =
                                        false;
                                  }
                                  newSetState(() {
                                    _passwordHidden2 = !_passwordHidden2;
                                  });
                                },
                              ),
                              "Re-type New Password",
                              "Leoscar",
                              17.0,
                              null),
                        ],
                      ),
                    ),
                  ),
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
                    child: methods.textOnly("Cancel", "Leoscar", 18.0,
                        Color(0XFF9866B3), FontWeight.bold, null, null),
                    onPressed: () {
                      Navigator.of(context).pop();
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
                    child: methods.textOnly("Submit", "Leoscar", 18.0,
                        Colors.white, FontWeight.bold, null, null),
                    onPressed: () {
                      String email = _forgetPasswordEmailController.text;
                      String password = _resetPasswordController.text;
                      String retypePassword =
                          _retypeResetPasswordController.text;
                      if (email.isNotEmpty &&
                          password.isNotEmpty &&
                          retypePassword.isNotEmpty) {
                        if (!_informationValidate[0]) {
                          methods.snackbarMessage(
                            context,
                            Duration(
                              seconds: 1,
                            ),
                            Colors.red[400],
                            methods.textOnly(
                                "Please insert a valid email format",
                                "Leoscar",
                                18.0,
                                Colors.white,
                                null,
                                null,
                                TextAlign.center),
                          );
                        } else if (!_informationValidate[1]) {
                        } else if (password == retypePassword) {
                          methods.snackbarMessage(
                            context,
                            Duration(
                              seconds: 1,
                            ),
                            Color(0XFFB563E0),
                            methods.textOnly(
                                "Please check your email to reset password",
                                "Leoscar",
                                18.0,
                                Colors.white,
                                null,
                                null,
                                TextAlign.center),
                          );
                          Navigator.of(context).pop();
                          setState(() {
                            _resetPasswordController.clear();
                          });
                          // http.post(urlForgetPassword, body: {
                          //   "email": email,
                          //   "password": password,
                          // }).then((res) {
                          //   if (res.body == "success") {
                          //     methods.showMessage(
                          //         "Please check your email to reset password",
                          //         Toast.LENGTH_SHORT,
                          //         ToastGravity.CENTER,
                          //         Colors.orange,
                          //         Colors.white,
                          //         16.0);
                          //     Navigator.of(context).pop();
                          //     setState(() {
                          //       _passwordController.clear();
                          //       _isChecked = false;
                          //     });
                          //   } else {
                          //     methods.showMessage(
                          //         "Failed, please try again or contact admin!",
                          //         Toast.LENGTH_SHORT,
                          //         ToastGravity.CENTER,
                          //         Colors.red,
                          //         Colors.white,
                          //         16.0);
                          //   }
                          // });
                        } else {
                          methods.snackbarMessage(
                            context,
                            Duration(
                              seconds: 1,
                            ),
                            Colors.red[400],
                            methods.textOnly(
                                "Password not match",
                                "Leoscar",
                                18.0,
                                Colors.white,
                                null,
                                null,
                                TextAlign.center),
                          );
                        }
                      } else {
                        methods.snackbarMessage(
                          context,
                          Duration(
                            seconds: 1,
                          ),
                          Colors.red[400],
                          methods.textOnly(
                              "Please fill in all the blank(s)",
                              "Leoscar",
                              18.0,
                              Colors.white,
                              null,
                              null,
                              TextAlign.center),
                        );
                      }
                    },
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  } //end _forgetPassword method

  //start _resendVerificationEmail method
  void _resendVerificationEmail() {
    TextEditingController _resendverificationEmailController =
        TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            primarySwatch: MaterialColor(0XFF9866B3, _swatch),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Color(0XFF9866B3),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: AlertDialog(
              title: methods.textOnly(
                  "Resend Verification Email?",
                  "Leoscar",
                  26.0,
                  Color(0XFF7100AD),
                  FontWeight.bold,
                  FontStyle.normal,
                  TextAlign.start),
              content: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: methods.textFormField(
                    null,
                    null,
                    TextInputAction.done,
                    TextInputType.emailAddress,
                    false,
                    _resendverificationEmailController,
                    _validateEmail,
                    Icon(
                      FlutterIcons.email_outline_mco,
                      size: 22.0,
                    ),
                    null,
                    "Email",
                    "Leoscar",
                    17.0,
                    null),
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
                  child: methods.textOnly("Cancel", "Leoscar", 18.0,
                      Color(0XFF9866B3), FontWeight.bold, null, null),
                  onPressed: () {
                    Navigator.of(context).pop();
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
                  child: methods.textOnly("Resend", "Leoscar", 18.0,
                      Colors.white, FontWeight.bold, null, null),
                  onPressed: () async {
                    if (_resendverificationEmailController.text.isNotEmpty &&
                        _informationValidate1) {
                      await http.post(
                          Uri.parse(
                              "https://lifemaintenanceapplication.000webhostapp.com/php/resendverificationemail.php"),
                          body: {
                            'email': _resendverificationEmailController.text,
                          }).then((res) {
                        print(res.body);
                        if (res.body == "success") {
                          methods.snackbarMessage(
                            context,
                            Duration(
                              seconds: 3,
                            ),
                            Color(0XFFB563E0),
                            methods.textOnly(
                                "Verification email resend, please check your email",
                                "Leoscar",
                                18.0,
                                Colors.white,
                                null,
                                null,
                                TextAlign.center),
                          );
                          Navigator.of(context).pop();
                        } else {
                          methods.snackbarMessage(
                            context,
                            Duration(
                              seconds: 1,
                            ),
                            Colors.red[400],
                            methods.textOnly(
                                "Unable to resend verification email...Please try again",
                                "Leoscar",
                                18.0,
                                Colors.white,
                                null,
                                null,
                                TextAlign.center),
                          );
                        }
                      });

                      // String email = _resendverificationEmailController.text;
                      // http.post(urlResend, body: {
                      //   //find database with the email inserted
                      //   "email": email,
                      // });
                      // Navigator.of(context).pop();
                      // methods.showMessage(
                      //     "Confimation email resend, please check your email",
                      //     Toast.LENGTH_SHORT,
                      //     ToastGravity.CENTER,
                      //     Colors.orange,
                      //     Colors.white,
                      //     16.0);
                    } else if (_resendverificationEmailController
                            .text.isNotEmpty &&
                        !_informationValidate1) {
                      methods.snackbarMessage(
                        context,
                        Duration(
                          seconds: 1,
                        ),
                        Colors.red[400],
                        methods.textOnly(
                            "Please insert a valid email format",
                            "Leoscar",
                            18.0,
                            Colors.white,
                            null,
                            null,
                            TextAlign.center),
                      );
                    } else {
                      methods.snackbarMessage(
                        context,
                        Duration(
                          seconds: 1,
                        ),
                        Colors.red[400],
                        methods.textOnly("Please insert your email", "Leoscar",
                            18.0, Colors.white, null, null, TextAlign.center),
                      );
                    }
                  },
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
          ),
        );
      },
    );
  } //end _resendVerificationEmail method

  //start _login method
  void _login() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      await http.post(
          Uri.parse(
              "https://lifemaintenanceapplication.000webhostapp.com/php/login.php"),
          body: {
            'email': _emailController.text,
            'password': _passwordController.text,
          }).then((res) {
        List userDetails = res.body.split("&");
        if (userDetails[0] == "success admin") {
          User user = new User(userDetails[1], userDetails[2], userDetails[3],
              userDetails[4], userDetails[5], userDetails[6], userDetails[7]);
          Navigator.push(
            context,
            PageTransition(
              child: Tabs(
                user: user,
              ),
              type: PageTransitionType.fade,
            ),
          );
          if (_isChecked) {
            _savePref(1); //call _savePref method
          } else {
            _savePref(2); //call _savePref method
          }
          methods.snackbarMessage(
            context,
            Duration(
              seconds: 1,
            ),
            Color(0XFFB563E0),
            methods.textOnly("Login successful...Welcome ${user.getName()}",
                "Leoscar", 18.0, Colors.white, null, null, TextAlign.center),
          );
        } else if (userDetails[0] == "success") {
          User user = new User(userDetails[1], userDetails[2], userDetails[3],
              userDetails[4], userDetails[5], userDetails[6], userDetails[7]);
          Navigator.push(
            context,
            PageTransition(
              child: Tabs(
                user: user,
              ),
              type: PageTransitionType.fade,
            ),
          );
          if (_isChecked) {
            _savePref(1); //call _savePref method
          } else {
            _savePref(2); //call _savePref method
          }
          methods.snackbarMessage(
            context,
            Duration(
              seconds: 1,
            ),
            Color(0XFFB563E0),
            methods.textOnly("Login successful...Welcome ${user.getName()}",
                "Leoscar", 18.0, Colors.white, null, null, TextAlign.center),
          );
        } else if (res.body == "incorrect password") {
          methods.snackbarMessage(
            context,
            Duration(
              seconds: 1,
            ),
            Colors.red[400],
            methods.textOnly("Incorrect password...Please try again", "Leoscar",
                18.0, Colors.white, null, null, TextAlign.center),
          );
        } else if (res.body == "no verify success") {
          methods.snackbarMessage(
            context,
            Duration(
              seconds: 1,
            ),
            Colors.red[400],
            methods.textOnly("Please check your email to activate this account",
                "Leoscar", 18.0, Colors.white, null, null, TextAlign.center),
          );
        } else {
          methods.snackbarMessage(
            context,
            Duration(
              seconds: 1,
            ),
            Colors.red[400],
            methods.textOnly("Incorrect email/password...Please try again",
                "Leoscar", 18.0, Colors.white, null, null, TextAlign.center),
          );
        }
      });
    } else {
      methods.snackbarMessage(
        context,
        Duration(
          seconds: 1,
        ),
        Colors.red[400],
        methods.textOnly("Please fill in all the blank(s)", "Leoscar", 18.0,
            Colors.white, null, null, TextAlign.center),
      );
    }
  } //end _login method

  //start _showEULA method
  void _showEULA() {
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: AlertDialog(
            title: Text(
              "EULA of Life Maintenance Application",
              style: TextStyle(
                fontFamily: "Leoscar",
                fontSize: 24.0,
                letterSpacing: 1.0,
                color: Color(0XFF7100AD),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: new Container(
              height: _screenHeight / 2,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: new SingleChildScrollView(
                      child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          text:
                              "This End-User License Agreement (\"EULA\") is a legal agreement between you and Life Maintenance Application.\n\nThis EULA agreement governs your acquisition and use of our Life Maintenance Application (\"Application\") directly from Life Maintenance Application or indirectly through a Life Maintenance Application authorized reseller or distributor (a \"Reseller\").\n\nPlease read this EULA agreement carefully before completing the installation process and using the Life Maintenance Application software. It provides a license to use the Life Maintenance Application and contains warranty information and liability disclaimers.\n\nIf you register for a free trial of the Life Maintenance Application, this EULA agreement will also govern that trial. By clicking \"accept\" or installing and/or using the Life Maintenance Application, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement.\n\nIf you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.\n\nThis EULA agreement shall apply only to the Software supplied by Life Maintenance Application here with regardless of whether other software is referred to or described herein. The terms also apply to any Life Maintenance Application updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for Life Maintenance Application.",
                        ),
                      ),
                    ),
                  )
                ],
              ),
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
                child: methods.textOnly(
                    "Cancel",
                    "Leoscar",
                    18.0,
                    Color(0XFF9866B3),
                    FontWeight.bold,
                    FontStyle.normal,
                    TextAlign.start),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                  setState(() {
                    _isChecked1 = false;
                  });
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
                child: methods.textOnly("Accept", "Leoscar", 18.0, Colors.white,
                    FontWeight.bold, FontStyle.normal, TextAlign.start),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                  setState(() {
                    _isChecked1 = true;
                  });
                },
              )
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
        );
      },
    );
  } //end _showEULA method

  //start _signUp method
  void _signUp() async {
    //test if all blanks is not empty
    if (_nameController1.text.isNotEmpty &&
        _dobController.text.isNotEmpty &&
        _genderController.text.isNotEmpty &&
        _emailController1.text.isNotEmpty &&
        _phoneController1.text.isNotEmpty &&
        _passwordController1.text.isNotEmpty &&
        _retypePasswordController1.text.isNotEmpty) {
      if (_informationValidate2[0] == true &&
          _informationValidate2[1] == true &&
          _informationValidate2[2] == true &&
          _informationValidate2[3] == true &&
          _informationValidate2[4] == true &&
          _informationValidate2[5] == true &&
          _informationValidate2[6] == true &&
          _isChecked1 == true) {
        //add user data into database
        await http.post(
            Uri.parse(
                "https://lifemaintenanceapplication.000webhostapp.com/php/signup.php"),
            body: {
              "name": _nameController1.text,
              "dob": _dobController.text,
              "gender": _genderController.text,
              "email": _emailController1.text,
              "phone": _phoneController1.text,
              "password": _passwordController1.text,
            }).then((res) {
          print(res.body);
          if (res.body == "success") {
            //if successfully added to database then pop signupscreen
            setState(() {
              _loginPressed = true;
              _nameController1.clear();
              _dobController.clear();
              _genderController.clear();
              _emailController1.clear();
              _phoneController1.clear();
              _passwordController1.clear();
              _retypePasswordController1.clear();
              _buttonClicked = 0;
              _isChecked1 = false;
              _passwordHidden3 = true;
              _passwordHidden4 = true;
              _loginPressed = true;
            });
            // setState(() {
            //   user = new User(
            //       _nameController1.text,
            //       _dobController.text,
            //       _genderController.text,
            //       _emailController1.text,
            //       _phoneController1.text,
            //       _retypePasswordController1.text);
            //   _emailController.text = _emailController1.text;
            //   _nameController1.clear();
            //   _dobController.clear();
            //   _genderController.clear();
            //   _emailController1.clear();
            //   _phoneController1.clear();
            //   _passwordController1.clear();
            //   _retypePasswordController1.clear();
            //   _buttonClicked = 0;
            //   _isChecked1 = false;
            //   _passwordHidden3 = true;
            //   _passwordHidden4 = true;
            //   _loginPressed = true;
            // });
            methods.snackbarMessage(
              context,
              Duration(
                seconds: 3,
              ),
              Color(0XFFB563E0),
              methods.textOnly(
                  "Registration success, please check your email to verify your account",
                  "Leoscar",
                  18.0,
                  Colors.white,
                  null,
                  null,
                  TextAlign.center),
            );
          } else {
            methods.snackbarMessage(
              context,
              Duration(
                seconds: 3,
              ),
              Colors.red[400],
              methods.textOnly("Registration failed", "Leoscar", 18.0,
                  Colors.white, null, null, TextAlign.center),
            );
          }
        }).catchError((err) {
          print(err);
        });
      } else if (_informationValidate2[0] == false ||
          _informationValidate2[1] == false ||
          _informationValidate2[2] == false ||
          _informationValidate2[3] == false ||
          _informationValidate2[4] == false ||
          _informationValidate2[5] == false ||
          _informationValidate2[6] == false) {
        methods.snackbarMessage(
          context,
          Duration(
            seconds: 1,
          ),
          Colors.red[400],
          methods.textOnly("Please amend the error(s)", "Leoscar", 18.0,
              Colors.white, null, null, TextAlign.center),
        );

        //test whether user agree EULA or not
      } else if (_isChecked1 == false) {
        methods.snackbarMessage(
          context,
          Duration(
            seconds: 1,
          ),
          Colors.red[400],
          methods.textOnly("Please accept the License Agreement", "Leoscar",
              18.0, Colors.white, null, null, TextAlign.center),
        );
        Future.delayed(Duration(milliseconds: 500), () {
          _showEULA();
        });
      }
    } //test if any blanks is empty
    else {
      methods.snackbarMessage(
        context,
        Duration(
          seconds: 1,
        ),
        Colors.red[400],
        methods.textOnly("Please fill in all the blank(s)", "Leoscar", 18.0,
            Colors.white, null, null, TextAlign.center),
      );
    }
  } //end _signUp method

  //start _validateEmail method
  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[com]{3,}))$';
    RegExp regex = new RegExp(pattern);
    String _error = "\u26A0 Please insert a valid email format";
    if (_buttonClicked == 1) {
      if (!regex.hasMatch(value)) {
        _informationValidate[0] = false;
        return _error;
      } else {
        _informationValidate[0] = true;
        return null;
      }
    } else if (_buttonClicked == 2) {
      if (!regex.hasMatch(value)) {
        _informationValidate1 = false;
        return _error;
      } else {
        _informationValidate1 = true;
        return null;
      }
    } else {
      if (!regex.hasMatch(value)) {
        _informationValidate2[3] = false;
        return _error;
      } else {
        _informationValidate2[3] = true;
        return null;
      }
    }
  } //end _validateEmail method

  //start _validatePassword method
  String _validatePassword(String value) {
    String _error = "\u26A0 Password must be at least ";

    if (value.length < 6) {
      return _error + "6 characters";
    } else if (!value.contains(new RegExp(r"(?=.*?[A-Z])"))) {
      _buttonClicked == 1
          ? _informationValidate[1] = false
          : _informationValidate2[5] = false;
      return _error + "1 uppercase letter";
    } else if (!value.contains(new RegExp(r"(?=.*?[a-z])"))) {
      _buttonClicked == 1
          ? _informationValidate[1] = false
          : _informationValidate2[5] = false;
      return _error + " 1 lowercase letter";
    } else if (!value.contains(new RegExp(r"(?=.*?[0-9])"))) {
      _buttonClicked == 1
          ? _informationValidate[1] = false
          : _informationValidate2[5] = false;
      return _error + "1 number";
    } else if (!value.contains(new RegExp(r"(?=.*?[#?!@$%^&*-])"))) {
      _buttonClicked == 1
          ? _informationValidate[1] = false
          : _informationValidate2[5] = false;
      return _error + "1 special character";
    } else {
      _buttonClicked == 1
          ? _informationValidate[1] = true
          : _informationValidate2[5] = true;
      return null;
    }
  } //end _validatePassword method

  //start _validateRetypePassword method
  String _validateRetypePassword(String value) {
    String _error = "\u26A0 Password not match";
    if (_buttonClicked == 1) {
      _informationValidate[2] = false;
      if (value != _resetPasswordController.text) {
        return _error;
      } else {
        _informationValidate[2] = true;
        return null;
      }
    } else {
      if (value != _passwordController1.text) {
        _informationValidate2[6] = false;
        return _error;
      } else {
        _informationValidate2[6] = true;
        return null;
      }
    }
  } //end _validateRetypePassword method

  //start _validateName1 method
  String _validateName(String value) {
    if (value.length < 3) {
      _informationValidate2[0] = false;
      return '\u26A0 Name must be more than 2 charater';
    } else {
      _informationValidate2[0] = true;
      return null;
    }
  } //end _validateName1 method

  //start _validateDOB method
  String _validateDOB(String value) {
    if (value.length != 0 && value != " ") {
      _informationValidate2[1] = true;
      return null;
    } else {
      _informationValidate2[1] = false;
      return '\u26A0 Please insert your date of birth';
    }
  } //end _validateDOB method

  //start _validateGender method
  String _validateGender(String value) {
    if (value.isEmpty) {
      _informationValidate2[2] = false;
      return '\u26A0 Please select your gender';
    } else {
      _informationValidate2[2] = true;
      return null;
    }
  } //end _validateGender method

  //start _validatePhone1 method
  String _validatePhone(String value) {
    if (value.length < 10 || value.length > 11) {
      _informationValidate2[4] = false;
      return '\u26A0 Phone number must be only 10/11 digits';
    } else {
      _informationValidate2[4] = true;
      return null;
    }
  } //end _validatePhone1 method
}
