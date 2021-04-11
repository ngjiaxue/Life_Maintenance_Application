import 'user.dart';
import 'additem.dart';
import 'methods.dart';
import 'package:flutter/material.dart';
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
                                                  Colors.black,
                                                  FontWeight.normal,
                                                  FontStyle.normal,
                                                  TextAlign.start),
                                              Spacer(),
                                              methods.textOnly(
                                                  "${widget.user.getUserExerciseList()[index]["calories"]} calories burned (per 30 minutes)",
                                                  "Leoscar",
                                                  18.0,
                                                  Colors.black,
                                                  FontWeight.normal,
                                                  FontStyle.normal,
                                                  TextAlign.start),
                                              Spacer(),
                                              methods.textOnly(
                                                  "Exercise duration: ${widget.user.getUserExerciseList()[index]["amount"]} minutes",
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
                                              "Total calories burned: ${widget.user.getUserExerciseList()[index]["totalcalories"]} calories",
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
                                              "Date added: ${widget.user.getUserExerciseList()[index]["date"]}",
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
                                          "assets/images/defaultprofile.png"),
                                ),
                                // child: Image.network(
                                //   widget.userExerciseList[index]["imagesource"],
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
                  backgroundColor: Colors.white,
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
                    Navigator.push(
                      context,
                      PageTransition(
                        child: AddItem(
                          option: "exercise",
                          // dbList: widget.exerciseList,
                          dbList: widget.user.getExerciseList(),
                          user: widget.user,
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

  @override
  bool get wantKeepAlive => true;
}
