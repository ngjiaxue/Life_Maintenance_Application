import 'user.dart';
import 'food.dart';
import 'methods.dart';
import "package:intl/intl.dart";
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class UserPage2 extends StatefulWidget {
  final User user;
  const UserPage2({Key key, this.user}) : super(key: key);
  @override
  _UserPage2State createState() => _UserPage2State();
}

class _UserPage2State extends State<UserPage2>
    with AutomaticKeepAliveClientMixin {
  Methods methods = new Methods();
  Food food;
  TextEditingController _amountController = TextEditingController();
  double _screenHeight;
  String _item;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Stack(
        children: [
          widget.user.getFoodList().length == 0
              ? Center(
                  child: methods.noRecordFound(5, 24.0),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: widget.user.getFoodList().length,
                  itemBuilder: (context, index) {
                    int _count = (widget.user.getFoodList().length - 1) - index;
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
                                          // color: Colors.orange,
                                          height: _screenHeight / 4.58,
                                          width: _screenHeight / 4.38,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              methods.textOnly(
                                                  widget.user
                                                      .getFoodList()[_count]
                                                      .getName(),
                                                  "Leoscar",
                                                  32.0,
                                                  Colors.black,
                                                  FontWeight.normal,
                                                  FontStyle.normal,
                                                  TextAlign.start),
                                              Spacer(),
                                              methods.textOnly(
                                                  "${widget.user.getFoodList()[_count].getCaloriesPer100g()} calories (per 100 grams)",
                                                  "Leoscar",
                                                  18.0,
                                                  Colors.black,
                                                  FontWeight.normal,
                                                  FontStyle.normal,
                                                  TextAlign.start),
                                              Spacer(),
                                              methods.textOnly(
                                                  "Amount taken: ${widget.user.getFoodList()[_count].getAmount()} grams",
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
                                          // color: Colors.green,
                                          child: methods.textOnly(
                                              // "Total calories: ${double.parse(_list[_count][1]) / 100 * double.parse(_list[_count][2])} calories",
                                              "Total calories: ${widget.user.getFoodList()[_count].getTotalCalories()} calories",
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
                                              "Date added: ${widget.user.getFoodList()[_count].getDate()}",
                                              // "Date added: " + _list[_count][3],
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
                                // color: Colors.pink,
                                child: Image.asset(
                                  widget.user
                                      .getFoodList()[_count]
                                      .getImageLocation(),
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
                  backgroundColor: Colors.white,
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.black12),
                  ),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: methods.color(),
                        tileMode: TileMode.clamp,
                      ).createShader(bounds);
                    },
                    child: Icon(
                      FlutterIcons.addfile_ant,
                      size: 30.0,
                      color: Colors.white,
                    ),
                  ),
                  heroTag: 1,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          StatefulBuilder(builder: (context, newSetState) {
                        return AlertDialog(
                          title: methods.textOnly(
                              "Add New Food?",
                              "Leoscar",
                              26.0,
                              Color(0XFF7100AD),
                              FontWeight.bold,
                              null,
                              null),
                          content: Container(
                            height: _screenHeight / 7,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      hint: methods.textOnly(
                                          "Select Food",
                                          "Leoscar",
                                          18.0,
                                          null,
                                          FontWeight.normal,
                                          FontStyle.normal,
                                          TextAlign.start),
                                      value: _item,
                                      items: [
                                        "Banana",
                                        "Apple",
                                        "Kuey Teow Soup",
                                        "Fried Chicken",
                                        "Orange",
                                        "Fried Rice",
                                        "Mango",
                                        "Nasi Lemak",
                                        "Chicken Chop",
                                        "Roti Canai"
                                      ]
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
                                      onChanged: (String _value) {
                                        newSetState(() {
                                          _item = _value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(),
                                  child: TextField(
                                    style: TextStyle(
                                      fontFamily: "Leoscar",
                                      fontSize: 17.0,
                                      letterSpacing: 1.0,
                                    ),
                                    controller: _amountController,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.number,
                                    cursorColor: Color(0XFF9866B3),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(20.0),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0XFF9866B3),
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                      hintText: "Amount taken (grams)",
                                      hintStyle: TextStyle(
                                        fontFamily: "Leoscar",
                                        fontSize: 17.0,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            MaterialButton(
                              highlightColor: Colors.transparent,
                              splashColor: Color(0XFFE7BAFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _amountController.clear();
                                _item = null;
                              },
                              child: methods.textOnly(
                                  "Cancel",
                                  "Leoscar",
                                  18.0,
                                  Color(0XFF9866B3),
                                  FontWeight.bold,
                                  null,
                                  null),
                            ),
                            MaterialButton(
                              highlightColor: Colors.transparent,
                              splashColor: Color(0XFFE7BAFF),
                              color: Color(0XFF9866B3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              onPressed: () {
                                DateFormat dateFormat =
                                    DateFormat("yyyy-MM-dd HH:mm:ss");
                                Navigator.of(context).pop();
                                setState(() {
                                  widget.user.setFoodList(Food(
                                      _item,
                                      _amountController.text,
                                      dateFormat
                                          .format(DateTime.now())
                                          .toString()));
                                  _amountController.clear();
                                  _item = null;
                                });
                              },
                              child: methods.textOnly("Add", "Leoscar", 18.0,
                                  Colors.white, FontWeight.bold, null, null),
                            ),
                          ],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        );
                      }),
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
