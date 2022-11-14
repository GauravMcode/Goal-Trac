import 'package:flutter/material.dart';
import 'package:scheduleyourday/LogicComponent.dart';
import 'package:scheduleyourday/Schedule.dart';
import 'package:scheduleyourday/Task.dart';
import 'HomePage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'custompaints.dart';
import 'package:google_fonts/google_fonts.dart';

Widget logoAppearWidget(
  double height,
  double width,
  AnimationController _animationController1,
  _animationController2,
  _animationController3,
  double? scalingLogo,
  double? transformLogo,
) {
  return Stack(
    children: [
      Positioned(
        left: 0,
        top: height * 0.22,
        child: Container(
          height: height * 0.4,
          width: width * 1.04,
          child: AnimatedBuilder(
              animation: _animationController1,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animationController1.value,
                  child: CustomPaint(
                    painter: LogoCustomPainter1(true),
                    child: Container(
                      alignment: Alignment.center,
                      width: width * 0.20,
                      height: height * 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Schedule\nPlanner",
                            style: GoogleFonts.pacifico(color: colors[2], fontStyle: FontStyle.italic, fontSize: 40),
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
        top: height * 0.22,
        child: AnimatedBuilder(
            animation: _animationController2,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset((1 - _animationController2.value!) * width, 0),
                child: SizedBox(
                  height: (height * 0.4),
                  width: (width * 1.04),
                  child: CustomPaint(
                    painter: LogoCustomPainter2(),
                    child: Container(
                      margin: EdgeInsets.only(left: width * 0.7, right: width * 0.1),
                      alignment: Alignment.center,
                      width: width * 0.20,
                      height: height * 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
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
    ],
  );
}

Widget logoFadeWidget(
  double height,
  double width,
  Animation<double> _animation3,
  double? scalingLogo,
  double? transformLogo,
) {
  return Stack(
    children: [
      Positioned(
        left: 0,
        top: height * 0.22,
        child: Container(
          height: height * 0.4,
          width: width * 1.04,
          child: FadeTransition(
            opacity: _animation3,
            child: CustomPaint(
              painter: LogoCustomPainter1(true),
              child: FadeTransition(
                opacity: _animation3,
                child: Container(
                  alignment: Alignment.center,
                  width: width * 0.20,
                  height: height * 0.08,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Schedule\nPlanner",
                        style: GoogleFonts.pacifico(color: colors[2], fontStyle: FontStyle.italic, fontSize: 40),
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
        ),
      ),
      Positioned(
        left: 0,
        top: height * 0.22,
        child: SizedBox(
          height: (height * 0.4),
          width: (width * 1.04),
          child: FadeTransition(
            opacity: _animation3,
            child: CustomPaint(
              painter: LogoCustomPainter2(),
              child: Container(
                margin: EdgeInsets.only(left: width * 0.7, right: width * 0.1),
                alignment: Alignment.center,
                width: width * 0.20,
                height: height * 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Plan\nYour\nDay!",
                      style: GoogleFonts.pacifico(color: colors[0], fontStyle: FontStyle.italic, fontSize: 30),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
