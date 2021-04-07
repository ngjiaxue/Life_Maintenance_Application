// import 'package:badges/badges.dart';
// import 'package:flutter/material.dart';

// const double ICON_OFF = -3;
// const double ICON_ON = 0;
// const double TEXT_OFF = 3;
// const double TEXT_ON = 1;
// const double ALPHA_OFF = 0;
// const double ALPHA_ON = 1;
// const int ANIM_DURATION = 300;

// class TabItem extends StatefulWidget {
//   final String title;
//   final bool selected;
//   final IconData iconData;
//   final TextStyle textStyle;
//   final Function callbackFunction;
//   final List<Color> tabIconColor, tabSelectedColor;

//   TabItem({
//     @required this.title,
//     @required this.selected,
//     @required this.iconData,
//     @required this.textStyle,
//     @required this.tabIconColor,
//     @required this.tabSelectedColor,
//     @required this.callbackFunction,
//   });

//   @override
//   _TabItemState createState() => _TabItemState();
// }

// class _TabItemState extends State<TabItem> {
//   double iconYAlign = ICON_ON;
//   double textYAlign = TEXT_OFF;
//   double iconAlpha = ALPHA_ON;

//   @override
//   void initState() {
//     super.initState();
//     _setIconTextAlpha();
//   }

//   @override
//   void didUpdateWidget(TabItem oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _setIconTextAlpha();
//   }

//   _setIconTextAlpha() {
//     setState(() {
//       iconYAlign = (widget.selected) ? ICON_OFF : ICON_ON;
//       textYAlign = (widget.selected) ? TEXT_ON : TEXT_OFF;
//       iconAlpha = (widget.selected) ? ALPHA_OFF : ALPHA_ON;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           Container(
//             height: double.infinity,
//             width: double.infinity,
//             child: AnimatedAlign(
//               duration: Duration(milliseconds: ANIM_DURATION),
//               alignment: Alignment(0, textYAlign),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   widget.title,
//                   style: widget.textStyle,
//                   maxLines: 1,
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             height: double.infinity,
//             width: double.infinity,
//             child: AnimatedAlign(
//               duration: Duration(milliseconds: ANIM_DURATION),
//               curve: Curves.easeIn,
//               alignment: Alignment(0, iconYAlign),
//               child: AnimatedOpacity(
//                 duration: Duration(milliseconds: ANIM_DURATION),
//                 opacity: iconAlpha,
//                 child: IconButton(
//                   highlightColor: Colors.transparent,
//                   splashColor: Colors.transparent,
//                   padding: EdgeInsets.all(0),
//                   alignment: Alignment(0, 0),
//                   icon: Badge(
//                     badgeContent: Text(
//                       "2",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 11.0,
//                       ),
//                     ),
//                     animationType: BadgeAnimationType.scale,
//                     elevation: 6,
//                     position: BadgePosition.topEnd(
//                       top: -10,
//                       end: -10,
//                     ),
//                     child: ShaderMask(
//                       shaderCallback: (Rect bounds) {
//                         return LinearGradient(
//                           begin: Alignment.bottomCenter,
//                           end: Alignment.topCenter,
//                           colors: widget.tabIconColor,
//                           tileMode: TileMode.clamp,
//                         ).createShader(bounds);
//                       },
//                       child: Icon(
//                         widget.iconData,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   onPressed: () {
//                     widget.callbackFunction();
//                   },
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
