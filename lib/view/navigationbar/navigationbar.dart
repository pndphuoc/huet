import 'package:flutter/material.dart';

class BottomNavBarV2 extends StatefulWidget {
  @override
  _BottomNavBarV2State createState() => _BottomNavBarV2State();
}

class _BottomNavBarV2State extends State<BottomNavBarV2> {
  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(context);
  }

  NavigationBar(context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 65,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 80),
              painter: BNBCustomPainter(),
            ),
            Center(
              heightFactor: 0.3,
              child: FloatingActionButton(
                  backgroundColor: Color.fromARGB(255, 104, 104, 172),
                  child: Icon(Icons.qr_code_2_outlined),
                  elevation: 0.1,
                  onPressed: () {}),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 65,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: currentIndex == 0
                          ? Color.fromARGB(255, 104, 104, 172)
                          : Colors.grey.shade400,
                    ),
                    onPressed: () {
                      setBottomBarIndex(0);
                    },
                    splashColor: Colors.white,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.hotel_outlined,
                        color: currentIndex == 1
                            ? Color.fromARGB(255, 104, 104, 172)
                            : Colors.grey.shade400,
                      ),
                      onPressed: () {
                        setBottomBarIndex(1);
                      }),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.restaurant_menu,
                        color: currentIndex == 2
                            ? Color.fromARGB(255, 104, 104, 172)
                            : Colors.grey.shade400,
                      ),
                      onPressed: () {
                        setBottomBarIndex(2);
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.place_outlined,
                        color: currentIndex == 3
                            ? Color.fromARGB(255, 104, 104, 172)
                            : Colors.grey.shade400,
                      ),
                      onPressed: () {
                        setBottomBarIndex(3);
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 15, size.width * 0.35, 10);
    path.quadraticBezierTo(size.width * 0.30, -10, size.width * 0.40, 30);
    path.arcToPoint(Offset(size.width * 0.60, 30),
        radius: Radius.circular(60.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.70, -10, size.width * 0.65, 10);
    path.quadraticBezierTo(size.width * 0.80, 15, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
