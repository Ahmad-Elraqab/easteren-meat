import 'package:drivers/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppBar extends StatefulWidget {
  int i;
  String image;

  MyAppBar(this.i, {Key key, this.image}) : super(key: key);

  @override
  _MyAppBar createState() => _MyAppBar(i);
}

class _MyAppBar extends State<MyAppBar> {
  int i;

  _MyAppBar(this.i);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: i == 1 ? DiagonalPathClipper() : DiagonalPathClipper2(),
          child: Container(
            height: 360.h,
            color: red,
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsetsDirectional.only(top: 150.h),
            child: i == 1
                ? SvgPicture.asset(
                    "assets/images/login_logo.svg",
                    width: 390.w,
                    height: 390.w,
                  )
                : CircleAvatar(
                    radius: 165.w,
                    backgroundColor: white,
                    backgroundImage: NetworkImage(
                      widget.image,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class DiagonalPathClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0.0, size.height)
      ..lineTo(size.width, size.height - 50)
      ..lineTo(size.width, 0.0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class DiagonalPathClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0.0, size.height)
      ..lineTo(size.width, size.height - 25)
      ..lineTo(size.width, 0.0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
