import 'package:flutter/material.dart';
import 'package:scheduleyourday/Logic/LogicComponent.dart';
import 'package:scheduleyourday/view_Methods/Schedule.dart';
import 'package:scheduleyourday/Model/Task.dart';
import '../Screens/HomePage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'custompaints.dart';
import 'package:google_fonts/google_fonts.dart';

Widget logoAppearWidget(
  double height,
  double width,
  AnimationController animationController1,
  animationController2,
  animationController3,
  double? scalingLogo,
  double? transformLogo,
) {
  double Pheight = height * 0.2;
  double logoHeight = height * 0.8;
  return Stack(
    children: [
      Positioned(
        left: 0,
        top: Pheight,
        child: SizedBox(
          height: logoHeight,
          width: width * 1.4,
          child: AnimatedBuilder(
              animation: animationController1,
              builder: (context, child) {
                return Transform.scale(
                  scale: animationController1.value,
                  child: CustomPaint(
                    painter: LogoCustomPainter1(true),
                    child: Container(
                      alignment: Alignment.center,
                      width: width * 0.20,
                      height: height * 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Goal\n    Trac",
                            style: TextStyle(color: colors[2], fontStyle: FontStyle.italic, fontSize: 85),
                          ),
                          SizedBox(
                            width: width * 0.3,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
      Positioned(
        left: 0,
        top: Pheight,
        child: AnimatedBuilder(
            animation: animationController2,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset((1 - animationController2.value!) * width, 0),
                child: SizedBox(
                  height: logoHeight,
                  width: width * 1.4,
                  child: CustomPaint(
                    painter: LogoCustomPainter2(false),
                    child: Container(
                      margin: EdgeInsets.only(left: width * 0.7, right: width * 0.1),
                      alignment: Alignment.center,
                      width: width,
                      height: height * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: width * 0.1),
                          Text(
                            "Plan\nYour\nDay!",
                            style: TextStyle(color: colors[0], fontStyle: FontStyle.italic, fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    ],
  );
}

Widget logoFadeWidget(double height, double width, Animation<double> animation3, double? scalingLogo, double? transformLogo, AnimationController animationController3) {
  double Pheight = height * 0.2;
  double logoHeight = height * 0.8;
  double logoWidth = width * 1.35;
  return Stack(
    children: [
      Positioned(
        left: 0,
        top: Pheight,
        child: SizedBox(
          height: logoHeight,
          width: logoWidth,
          child: AnimatedBuilder(
              animation: animationController3,
              builder: (context, child) {
                return Opacity(
                  opacity: 1 - animationController3.value,
                  child: CustomPaint(
                    painter: LogoCustomPainter1(false),
                    child: FadeTransition(
                      opacity: animation3,
                      child: Container(
                        alignment: Alignment.center,
                        width: width * 0.20,
                        height: height * 0.08,
                        child: FadeTransition(
                          opacity: animation3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Goal\n    Trac",
                                style: GoogleFonts.pacifico(fontStyle: FontStyle.italic, fontSize: 85),
                              ),
                              SizedBox(
                                width: width * 0.3,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
      Positioned(
        left: 0,
        top: Pheight,
        child: SizedBox(
          height: logoHeight,
          width: logoWidth,
          child: AnimatedBuilder(
              animation: animationController3,
              builder: (context, child) {
                return Opacity(
                  opacity: 1 - animationController3.value,
                  child: CustomPaint(
                    painter: LogoCustomPainter2(true),
                    child: Container(
                      margin: EdgeInsets.only(left: width * 0.7, right: width * 0.1),
                      alignment: Alignment.centerLeft,
                      width: width * 0.20,
                      height: height * 0.08,
                      child: FadeTransition(
                        opacity: animation3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: width * 0.1),
                            Text(
                              "Plan\nYour\nDay!",
                              style: GoogleFonts.pacifico(color: colors[0], fontStyle: FontStyle.italic, fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    ],
  );
}
