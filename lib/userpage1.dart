import 'dart:math';
import 'user.dart';
import 'methods.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart';
import 'package:line_icons/line_icons.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_icons/flutter_icons.dart';

class UserPage1 extends StatefulWidget {
  final User user;
  final VoidCallback callback1;
  final Function(int) func1;
  // final List userFoodList;
  // final List userExerciseList;
  const UserPage1(
      {Key key,
      this.user,
      // this.userFoodList,
      // this.userExerciseList,
      this.callback1,
      this.func1})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserPage1State(callback2: () {
      callback1();
    }, func2: (integer) {
      func1(integer);
    });
  }
}

class _UserPage1State extends State<UserPage1> {
  GlobalKey _toolTipKey = GlobalKey();
  VoidCallback callback2;
  Function(int) func2;
  _UserPage1State({this.callback2, this.func2});
  Methods methods = new Methods();
  double _screenHeight;
  double _height = 0.0;
  double _weight = 0.0;
  bool _toolTipShowing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _toolTipShowing = false;
          });
        },
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: _screenHeight / 5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/homebg.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        methods.textOnly(
                            "Hey, " + widget.user.getName(),
                            "Leoscar",
                            18.0,
                            Colors.white.withOpacity(0.7),
                            FontWeight.normal,
                            FontStyle.normal,
                            TextAlign.start),
                        SizedBox(
                          height: 5.0,
                        ),
                        methods.textOnly("Home", "Leoscar", 36.0, Colors.white,
                            FontWeight.bold, FontStyle.normal, TextAlign.start),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 110.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Card(
                    shadowColor: Colors.deepPurple[200],
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    child: Container(
                      height: _screenHeight / 6.5,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(
                          15.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _details(FlutterIcons.human_male_height_mco,
                                "Height: ", "${widget.user.getHeight()} cm"),
                            _details(FlutterIcons.weight_kilogram_mco,
                                "Weight: ", "${widget.user.getWeight()} kg"),
                            _details(
                                FlutterIcons.weight_faw5s,
                                "BMI: ",
                                widget.user.getHeight() == "0.0" ||
                                        widget.user.getWeight() == "0.0"
                                    ? "NaN"
                                    : "${(double.parse(widget.user.getWeight()) / pow((double.parse(widget.user.getHeight()) / 100), 2)).toStringAsFixed(1)}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Card(
                shadowColor: Colors.deepPurple[200],
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Container(
                  height: _screenHeight / 1.75,
                  width: double.infinity,
                  child: NestedTabBar(
                    user: widget.user,
                    // userFoodList: widget.userFoodList,
                    // userExerciseList: widget.userExerciseList,
                    screenHeight: _screenHeight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _details(IconData _icon, String _leading, String _content) {
    Color _color = Colors.black;
    if (_content == "0.0 cm" || _content == "0.0 kg" || _content == "NaN") {
      _color = Colors.red;
    }
    double _temp = double.tryParse(_content);
    String _bmiRange = "";
    if (_temp != null && !_temp.isNaN) {
      if (_temp < 18.5) {
        _bmiRange = " (Underweight)";
      } else if (_temp >= 18.5 && _temp < 25) {
        _bmiRange = " (Normal)";
      } else if (_temp >= 25 && _temp < 30) {
        _bmiRange = " (Overweight)";
      } else {
        _bmiRange = " (Obese)";
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: _leading == "BMI: "
                  ? EdgeInsets.only(
                      left: 2.0,
                    )
                  : EdgeInsets.all(
                      0.0,
                    ),
              child: Icon(
                _icon,
                color: _color,
                size: _leading == "BMI: " ? 20.0 : 24.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 4.0,
                left: _leading == "BMI: " ? 12.0 : 10.0,
              ),
              child: methods.textOnly(_leading, "Leoscar", 18.0, _color,
                  FontWeight.normal, FontStyle.normal, TextAlign.start),
            ),
          ],
        ),
        Row(
          children: [
            methods.textOnly(
                _content + _bmiRange,
                "Leoscar",
                18.0,
                (_temp != null && !_temp.isNaN && _temp >= 25)
                    ? Colors.red
                    : _color,
                FontWeight.normal,
                FontStyle.normal,
                TextAlign.start),
            _leading == "Height: " || _leading == "Weight: "
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                    ),
                    child: GestureDetector(
                      onTap: _leading == "Height: "
                          ? () => _showNumberPicker(0)
                          : () => _showNumberPicker(1),
                      child: methods.shaderMask(
                        Icon(
                          widget.user.getHeight() == "0.0" &&
                                  _leading == "Height: "
                              ? FlutterIcons.add_circle_outline_mdi
                              : widget.user.getWeight() == "0.0" &&
                                      _leading == "Weight: "
                                  ? FlutterIcons.add_circle_outline_mdi
                                  : FlutterIcons.circle_edit_outline_mco,
                          color: Colors.white,
                        ),
                        true,
                      ),
                    ),
                  )
                : _temp != null && !_temp.isNaN
                    ? SizedBox.shrink()
                    : SizedBox(
                        width: 35.0,
                      ),
            Visibility(
              visible: _temp != null && !_temp.isNaN,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 5.0,
                  bottom: 2.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    final dynamic tooltip = _toolTipKey.currentState;
                    if (!_toolTipShowing) {
                      tooltip.ensureTooltipVisible();
                      setState(() {
                        _toolTipShowing = true;
                      });
                    } else {
                      setState(() {
                        _toolTipShowing = false;
                      });
                    }
                  },
                  child: Tooltip(
                    key: _toolTipKey,
                    message:
                        "Below 18.5 -	Underweight\n18.5 – 24.9 -	Normal\n25.0 – 29.9	- Overweight\n30.0 and Above -	Obese",
                    textStyle: TextStyle(
                      fontFamily: "Leoscar",
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                    margin: EdgeInsets.only(
                      right: 14.0,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 10.0,
                    ),
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: methods
                            .color()
                            .map(
                              (color) => color.withOpacity(0.9),
                            )
                            .toList(),
                      ),
                      // color: Colors.white,
                      shape: TooltipShapeBorder(),
                      // border: Border.all(
                      //   color: Colors.black,
                      // ),
                      // borderRadius: BorderRadius.circular(8.0),
                    ),
                    verticalOffset: 15.0,
                    child: methods.shaderMask(
                      Icon(
                        FlutterIcons.question_circle_o_faw,
                        // size: 20.0,
                        color: Colors.white,
                      ),
                      true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showNumberPicker(int _index) {
    //0 = height, 1 = weight
    bool _loading = false;
    double _tempValue = _index == 0
        ? (_height != 0.0
            ? _height
            : widget.user.getHeight() == "0.0"
                ? 50.0
                : double.parse(widget.user.getHeight()))
        : (_weight != 0.0
            ? _weight
            : widget.user.getWeight() == "0.0"
                ? 30.0
                : double.parse(widget.user.getWeight()));
    methods.snackbarMessage(
      context,
      Duration(days: 365),
      Color(0XFFB563E0),
      false,
      StatefulBuilder(builder: (context, newSetState) {
        return _loading == false
            ? Container(
                height: _screenHeight / 4.5,
                child: Column(
                  children: [
                    methods.textOnly(
                        "Please insert your " +
                            (_index == 0 ? "height (cm)" : "weight (kg)"),
                        "Leoscar",
                        18.0,
                        Colors.white,
                        null,
                        null,
                        TextAlign.center),
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
                          onTap: () => ScaffoldMessenger.of(context)
                              .hideCurrentSnackBar(),
                        ),
                        DecimalNumberPicker(
                            minValue: _index == 0 ? 50 : 30,
                            maxValue: _index == 0 ? 200 : 300,
                            decimalPlaces: 1,
                            value: _tempValue,
                            onChanged: (value) {
                              newSetState(() {
                                _tempValue = value;
                              });
                            }),
                        GestureDetector(
                          child: Container(
                            child: Icon(
                              LineIcons.check,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () async {
                            newSetState(() {
                              _loading = true;
                            });
                            await http.post(
                                Uri.parse(
                                    "https://lifemaintenanceapplication.000webhostapp.com/php/editprofile.php"),
                                body: {
                                  "page1Edit": _index.toString(),
                                  "value": _tempValue.toString(),
                                  "email": widget.user.getEmail(),
                                }).then((res) {
                              if (res.body == "success") {
                                _index == 0
                                    ? widget.user.setHeight(
                                        _tempValue.toStringAsFixed(1))
                                    : widget.user.setWeight(
                                        _tempValue.toStringAsFixed(1));
                                Future.delayed(Duration(milliseconds: 500), () {
                                  methods.snackbarMessage(
                                    context,
                                    Duration(
                                      milliseconds: 1500,
                                    ),
                                    Color(0XFFB563E0),
                                    true,
                                    methods.textOnly(
                                        (_index == 0 ? "Height" : "Weight") +
                                            " updated successfully",
                                        "Leoscar",
                                        18.0,
                                        Colors.white,
                                        null,
                                        null,
                                        TextAlign.center),
                                  );
                                });
                              } else {
                                Future.delayed(Duration(milliseconds: 500), () {
                                  methods.snackbarMessage(
                                    context,
                                    Duration(
                                      seconds: 1,
                                    ),
                                    Colors.red[400],
                                    true,
                                    methods.textOnly(
                                        "Fail to update...Please try again",
                                        "Leoscar",
                                        18.0,
                                        Colors.white,
                                        null,
                                        null,
                                        TextAlign.center),
                                  );
                                });
                              }
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                setState(() {});
                              });
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ))
            : methods.textOnly("Loading......", "Leoscar", 20.0, Colors.white,
                FontWeight.normal, FontStyle.normal, TextAlign.center);
      }),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  final User user;
  final double screenHeight;
  // final List userFoodList;
  // final List userExerciseList;
  const NestedTabBar(
      {Key key,
      this.user,
      // this.userFoodList,
      // this.userExerciseList,
      this.screenHeight})
      : super(key: key);
  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  Methods methods = new Methods();
  TabController _nestedTabController;
  String _chartFilter = "Day";
  @override
  void initState() {
    super.initState();
    _nestedTabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          height: 40.0,
          child: TabBar(
            physics: NeverScrollableScrollPhysics(),
            controller: _nestedTabController,
            indicatorColor: Colors.cyan[200],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black54,
            tabs: [
              methods.shaderMask(
                Icon(
                  FlutterIcons.food_apple_outline_mco,
                ),
                true,
              ),
              methods.shaderMask(
                Icon(
                  FlutterIcons.running_faw5s,
                ),
                true,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                height: widget.screenHeight / 1.95,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _nestedTabController,
                  children: <Widget>[
                    widget.user.getUserFoodList().length == 0
                        ? Container(
                            height: widget.screenHeight / 2,
                            child: Center(
                              child: methods.noRecordFound(7, 20.0),
                            ),
                          )
                        : _contentInTabBarView(0),
                    widget.user.getUserExerciseList().length == 0
                        ? Container(
                            height: widget.screenHeight / 2,
                            child: Center(
                              child: methods.noRecordFound(7, 20.0),
                            ),
                          )
                        : _contentInTabBarView(1),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _contentInTabBarView(int _i) {
    //_i = 0 => food, _i = 1 => exercise
    List _list = [];
    double _highestCalories = 0;
    List<FlSpot> _data = [];

    if (_i == 0) {
      // _list = widget.userFoodList;
      setState(() {
        _list = widget.user.getUserFoodList();
      });
      for (int _i = 0; _i < _list.length; _i++) {
        _data.add(
          FlSpot(
            _i.toDouble(),
            double.parse(_list[_i]["calories"]) / 100,
          ),
        );

        if ((double.parse(_list[_i]["calories"]) / 100) > _highestCalories) {
          _highestCalories = (double.parse(_list[_i]["calories"]) / 100);
        }
      }
    } else {
      // _list = widget.userExerciseList;
      setState(() {
        _list = widget.user.getUserExerciseList();
      });
      for (int _i = 0; _i < _list.length; _i++) {
        _data.add(
          FlSpot(
            _i.toDouble(),
            double.parse(_list[_i]["calories"]) / 100,
          ),
        );

        if ((double.parse(_list[_i]["calories"]) / 100) > _highestCalories) {
          _highestCalories = (double.parse(_list[_i]["calories"]) / 100);
        }
      }
    }

    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 30.0,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _chartFilter,
                items: ["Day", "Week", "Month", "Year"]
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
                onChanged: (chartFilter) {
                  setState(() {
                    _chartFilter = chartFilter;
                  });
                },
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 15.0,
                  top: 50.0,
                  right: 30.0,
                  bottom: 15.0,
                ),
                height: widget.screenHeight / 1.95,
                width: double.infinity,
                child: _list.isNotEmpty
                    ? LineChart(
                        LineChartData(
                          clipData: FlClipData.all(),
                          minX: 0,
                          maxX: _list.length.toDouble() - 1,
                          minY: 0,
                          maxY: _highestCalories + 1,
                          lineTouchData: LineTouchData(
                            getTouchedSpotIndicator: (LineChartBarData barData,
                                List<int> spotIndexes) {
                              return spotIndexes.map((spotIndex) {
                                return TouchedSpotIndicatorData(
                                  FlLine(
                                    color: Colors.black12,
                                  ),
                                  FlDotData(
                                    getDotPainter:
                                        (spot, percent, barData, index) {
                                      return FlDotCirclePainter(
                                        radius: 6,
                                        color: Colors.white,
                                        strokeWidth: 3,
                                        strokeColor: Colors.black,
                                      );
                                    },
                                  ),
                                );
                              }).toList();
                            },
                            touchTooltipData: LineTouchTooltipData(
                                getTooltipItems:
                                    (List<LineBarSpot> touchedBarSpots) {
                              return touchedBarSpots.map((barSpot) {
                                return LineTooltipItem(
                                  _list[barSpot.x.toInt()]["name"] +
                                      "\n" +
                                      _list[barSpot.x.toInt()]["calories"],
                                  const TextStyle(
                                    fontFamily: "Leoscar",
                                    color: Colors.black,
                                  ),
                                );
                              }).toList();
                            }),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: SideTitles(
                                showTitles: true,
                                getTextStyles: (value) => const TextStyle(
                                      fontFamily: "Leoscar",
                                      color: Colors.black,
                                      fontSize: 11,
                                    ),
                                getTitles: (value) {
                                  return (value * 100).toStringAsFixed(0);
                                }),
                            bottomTitles: SideTitles(
                              rotateAngle: 330,
                              // showTitles: true,
                              showTitles: false,
                              getTextStyles: (value) => const TextStyle(
                                fontFamily: "Leoscar",
                                color: Colors.black,
                                fontSize: 10,
                              ),
                              getTitles: (value) {
                                return _list[value.toInt()]["name"];
                              },
                            ),
                          ),
                          // gridData: FlGridData(
                          //   drawVerticalLine: true,
                          // ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _data,
                              dotData: FlDotData(
                                show: false,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: Colors.white,
                                    strokeWidth: 2,
                                    strokeColor: Colors.black38,
                                  );
                                },
                              ),
                              isCurved: true,
                              // preventCurveOverShooting: true,
                              colors: methods.color(),
                              gradientFrom: Offset.fromDirection(1),
                              gradientTo: Offset.fromDirection(0),
                              barWidth: 5,
                              belowBarData: BarAreaData(
                                show: true,
                                colors: methods
                                    .color()
                                    .map(
                                      (color) => color.withOpacity(0.4),
                                    )
                                    .toList(),
                                gradientFrom: Offset.fromDirection(1),
                                gradientTo: Offset.fromDirection(0),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TooltipShapeBorder extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double arrowArc;
  final double radius;

  TooltipShapeBorder({
    this.radius = 8.0,
    this.arrowWidth = 20.0,
    this.arrowHeight = 10.0,
    this.arrowArc = 0.0,
  }) : assert(arrowArc <= 1.0 && arrowArc >= 0.0);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => null;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    rect = Rect.fromPoints(
        rect.topLeft, rect.bottomRight - Offset(0, arrowHeight));
    double x = arrowWidth, y = arrowHeight, r = 1 - arrowArc;
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)))
      ..moveTo(rect.topCenter.dx + 3 * x, rect.topCenter.dy)
      ..relativeLineTo(x / 2 * r, -y * r)
      ..relativeQuadraticBezierTo(
          -x / 2 * (1 - r), y * (1 - r), -x * (1 - r), 0)
      ..relativeLineTo(x / 2 * r, y * r);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
