import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = HexColor("ffc996");
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * (0.9167 - 0.68));
    path.quadraticBezierTo(size.width * 0.25, size.height * (0.875 - 0.68),
        size.width * 0.5, size.height * (0.9167 - 0.68));
    path.quadraticBezierTo(size.width * 0.75, size.height * (0.9584 - 0.68),
        size.width * 1.0, size.height * (0.9167 - 0.68));
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
    // canvas.drawShadow(path, Colors.grey.withAlpha(50), 4.0, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double defaultSize;
  static Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double proH(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double proW(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

class SwipeConfiguration {
  //Vertical swipe configuration options
  double verticalSwipeMaxWidthThreshold = 50.0;
  double verticalSwipeMinDisplacement = 100.0;
  double verticalSwipeMinVelocity = 300.0;

  //Horizontal swipe configuration options
  double horizontalSwipeMaxHeightThreshold = 50.0;
  double horizontalSwipeMinDisplacement = 50.0;
  double horizontalSwipeMinVelocity = 300.0;

  SwipeConfiguration({
    double verticalSwipeMaxWidthThreshold,
    double verticalSwipeMinDisplacement,
    double verticalSwipeMinVelocity,
    double horizontalSwipeMaxHeightThreshold,
    double horizontalSwipeMinDisplacement,
    double horizontalSwipeMinVelocity,
  }) {
    if (verticalSwipeMaxWidthThreshold != null) {
      this.verticalSwipeMaxWidthThreshold = verticalSwipeMaxWidthThreshold;
    }

    if (verticalSwipeMinDisplacement != null) {
      this.verticalSwipeMinDisplacement = verticalSwipeMinDisplacement;
    }

    if (verticalSwipeMinVelocity != null) {
      this.verticalSwipeMinVelocity = verticalSwipeMinVelocity;
    }

    if (horizontalSwipeMaxHeightThreshold != null) {
      this.horizontalSwipeMaxHeightThreshold =
          horizontalSwipeMaxHeightThreshold;
    }

    if (horizontalSwipeMinDisplacement != null) {
      this.horizontalSwipeMinDisplacement = horizontalSwipeMinDisplacement;
    }

    if (horizontalSwipeMinVelocity != null) {
      this.horizontalSwipeMinVelocity = horizontalSwipeMinVelocity;
    }
  }
}

class SwipeDetector extends StatelessWidget {
  final Widget child;
  final Function() onSwipeUp;
  final Function() onSwipeDown;
  final Function() onSwipeLeft;
  final Function() onSwipeRight;
  final SwipeConfiguration swipeConfiguration;

  SwipeDetector(
      {@required this.child,
      this.onSwipeUp,
      this.onSwipeDown,
      this.onSwipeLeft,
      this.onSwipeRight,
      SwipeConfiguration swipeConfiguration})
      : this.swipeConfiguration = swipeConfiguration == null
            ? SwipeConfiguration()
            : swipeConfiguration;

  @override
  Widget build(BuildContext context) {
    //Vertical drag details
    DragStartDetails startVerticalDragDetails;
    DragUpdateDetails updateVerticalDragDetails;

    //Horizontal drag details
    DragStartDetails startHorizontalDragDetails;
    DragUpdateDetails updateHorizontalDragDetails;

    return GestureDetector(
      child: child,
      onVerticalDragStart: (dragDetails) {
        startVerticalDragDetails = dragDetails;
      },
      onVerticalDragUpdate: (dragDetails) {
        updateVerticalDragDetails = dragDetails;
      },
      onVerticalDragEnd: (endDetails) {
        double dx = updateVerticalDragDetails.globalPosition.dx -
            startVerticalDragDetails.globalPosition.dx;
        double dy = updateVerticalDragDetails.globalPosition.dy -
            startVerticalDragDetails.globalPosition.dy;
        double velocity = endDetails.primaryVelocity;

        //Convert values to be positive
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        double positiveVelocity = velocity < 0 ? -velocity : velocity;

        if (dx > swipeConfiguration.verticalSwipeMaxWidthThreshold) return;
        if (dy < swipeConfiguration.verticalSwipeMinDisplacement) return;
        if (positiveVelocity < swipeConfiguration.verticalSwipeMinVelocity)
          return;

        if (velocity < 0) {
          //Swipe Up
          if (onSwipeUp != null) {
            onSwipeUp();
          }
        } else {
          //Swipe Down
          if (onSwipeDown != null) {
            onSwipeDown();
          }
        }
      },
      onHorizontalDragStart: (dragDetails) {
        startHorizontalDragDetails = dragDetails;
      },
      onHorizontalDragUpdate: (dragDetails) {
        updateHorizontalDragDetails = dragDetails;
      },
      onHorizontalDragEnd: (endDetails) {
        double dx = updateHorizontalDragDetails.globalPosition.dx -
            startHorizontalDragDetails.globalPosition.dx;
        double dy = updateHorizontalDragDetails.globalPosition.dy -
            startHorizontalDragDetails.globalPosition.dy;
        double velocity = endDetails.primaryVelocity;

        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        double positiveVelocity = velocity < 0 ? -velocity : velocity;

        if (dx < swipeConfiguration.horizontalSwipeMinDisplacement) return;
        if (dy > swipeConfiguration.horizontalSwipeMaxHeightThreshold) return;
        if (positiveVelocity < swipeConfiguration.horizontalSwipeMinVelocity)
          return;

        if (velocity < 0) {
          //Swipe Up
          if (onSwipeLeft != null) {
            onSwipeLeft();
          }
        } else {
          //Swipe Down
          if (onSwipeRight != null) {
            onSwipeRight();
          }
        }
      },
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1

    paint.color = Color(0xfff7d4a2);
    path = Path();
    path.lineTo(0, 0);
    path.cubicTo(0, 0, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width, size.height * 0.16, size.width,
        size.height * 0.16);
    path.cubicTo(size.width, size.height * 0.16, size.width * 0.83,
        size.height * 0.22, size.width * 0.83, size.height * 0.22);
    path.cubicTo(size.width * 0.83, size.height * 0.22, size.width * 0.82,
        size.height * 0.34, size.width * 0.82, size.height * 0.34);
    path.cubicTo(size.width * 0.82, size.height * 0.34, size.width * 0.7,
        size.height * 0.39, size.width * 0.7, size.height * 0.39);
    path.cubicTo(size.width * 0.7, size.height * 0.39, size.width * 0.7,
        size.height / 3, size.width * 0.7, size.height / 3);
    path.cubicTo(size.width * 0.7, size.height / 3, size.width * 0.64,
        size.height / 3, size.width * 0.64, size.height / 3);
    path.cubicTo(size.width * 0.64, size.height / 3, size.width * 0.64,
        size.height * 0.39, size.width * 0.64, size.height * 0.39);
    path.cubicTo(size.width * 0.64, size.height * 0.39, size.width * 0.53,
        size.height * 0.39, size.width * 0.53, size.height * 0.39);
    path.cubicTo(size.width * 0.53, size.height * 0.39, size.width * 0.53,
        size.height / 3, size.width * 0.53, size.height / 3);
    path.cubicTo(size.width * 0.53, size.height / 3, size.width * 0.47,
        size.height / 3, size.width * 0.47, size.height / 3);
    path.cubicTo(size.width * 0.47, size.height / 3, size.width * 0.47,
        size.height * 0.39, size.width * 0.47, size.height * 0.39);
    path.cubicTo(size.width * 0.47, size.height * 0.39, size.width * 0.36,
        size.height * 0.39, size.width * 0.36, size.height * 0.39);
    path.cubicTo(size.width * 0.36, size.height * 0.39, size.width * 0.36,
        size.height / 3, size.width * 0.36, size.height / 3);
    path.cubicTo(size.width * 0.36, size.height / 3, size.width * 0.3,
        size.height / 3, size.width * 0.3, size.height / 3);
    path.cubicTo(size.width * 0.3, size.height / 3, size.width * 0.3,
        size.height * 0.39, size.width * 0.3, size.height * 0.39);
    path.cubicTo(size.width * 0.3, size.height * 0.39, size.width * 0.17,
        size.height * 0.34, size.width * 0.17, size.height * 0.34);
    path.cubicTo(size.width * 0.17, size.height * 0.34, size.width * 0.17,
        size.height * 0.24, size.width * 0.17, size.height * 0.24);
    path.cubicTo(size.width * 0.17, size.height * 0.24, 0, size.height * 0.16,
        0, size.height * 0.16);
    path.cubicTo(0, size.height * 0.16, 0, 0, 0, 0);
    canvas.drawPath(path, paint);

    // Path number 2

    paint.color = Color(0xfffff);
    path = Path();
    path.lineTo(0, size.height * 0.16);
    path.cubicTo(
        0, size.height * 0.16, 0, size.height * 1.16, 0, size.height * 1.16);
    path.cubicTo(0, size.height * 1.16, size.width, size.height * 1.16,
        size.width, size.height * 1.16);
    path.cubicTo(size.width, size.height * 1.16, size.width, size.height * 0.16,
        size.width, size.height * 0.16);
    path.cubicTo(size.width, size.height * 0.16, size.width * 0.82,
        size.height * 0.22, size.width * 0.82, size.height * 0.22);
    path.cubicTo(size.width * 0.82, size.height * 0.22, size.width * 0.82,
        size.height * 0.34, size.width * 0.82, size.height * 0.34);
    path.cubicTo(size.width * 0.82, size.height * 0.34, size.width * 0.7,
        size.height * 0.39, size.width * 0.7, size.height * 0.39);
    path.cubicTo(size.width * 0.7, size.height * 0.39, size.width * 0.7,
        size.height / 3, size.width * 0.7, size.height / 3);
    path.cubicTo(size.width * 0.7, size.height / 3, size.width * 0.64,
        size.height / 3, size.width * 0.64, size.height / 3);
    path.cubicTo(size.width * 0.64, size.height / 3, size.width * 0.64,
        size.height * 0.39, size.width * 0.64, size.height * 0.39);
    path.cubicTo(size.width * 0.64, size.height * 0.39, size.width * 0.53,
        size.height * 0.39, size.width * 0.53, size.height * 0.39);
    path.cubicTo(size.width * 0.53, size.height * 0.39, size.width * 0.53,
        size.height / 3, size.width * 0.53, size.height / 3);
    path.cubicTo(size.width * 0.53, size.height / 3, size.width * 0.47,
        size.height / 3, size.width * 0.47, size.height / 3);
    path.cubicTo(size.width * 0.47, size.height / 3, size.width * 0.47,
        size.height * 0.39, size.width * 0.47, size.height * 0.39);
    path.cubicTo(size.width * 0.47, size.height * 0.39, size.width * 0.36,
        size.height * 0.39, size.width * 0.36, size.height * 0.39);
    path.cubicTo(size.width * 0.36, size.height * 0.39, size.width * 0.36,
        size.height / 3, size.width * 0.36, size.height / 3);
    path.cubicTo(size.width * 0.36, size.height / 3, size.width * 0.3,
        size.height / 3, size.width * 0.3, size.height / 3);
    path.cubicTo(size.width * 0.3, size.height / 3, size.width * 0.3,
        size.height * 0.39, size.width * 0.3, size.height * 0.39);
    path.cubicTo(size.width * 0.3, size.height * 0.39, size.width * 0.17,
        size.height * 0.34, size.width * 0.17, size.height * 0.34);
    path.cubicTo(size.width * 0.17, size.height * 0.34, size.width * 0.17,
        size.height * 0.24, size.width * 0.17, size.height * 0.24);
    path.cubicTo(size.width * 0.17, size.height * 0.24, 0, size.height * 0.16,
        0, size.height * 0.16);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
