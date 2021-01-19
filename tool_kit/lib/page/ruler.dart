import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tool_kit/utils/global.dart';

class RulerPage extends StatefulWidget {
  RulerPage({Key key}) : super(key: key);
  @override
  _RulerPageState createState() => _RulerPageState();
}

class _RulerPageState extends State<RulerPage> {
  final double _left = MediaQueryData.fromWindow(window).padding.top;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            RulerWidget(padding: _left),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(_left, 10, 10, 10),
                decoration: BoxDecoration(color: Global.primaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RaisedButton.icon(
                      color: Colors.white,
                      elevation: 0,
                      icon: Icon(
                        Icons.home,
                        color: Global.primaryColor,
                        size: 20,
                      ),
                      label: Text(
                        '返回首页',
                        style: TextStyle(
                          color: Global.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//绘制尺子
class RulerWidget extends StatefulWidget {
  final double lineWidth; //5mm、10mm刻度宽度
  final double line1Width; //1mm刻度宽度
  final double line1Height; //1mm刻度高度
  final double line2Height; //5mm刻度高度
  final double line3Height; //10mm刻度高度
  final double padding; //尺子两端距离屏幕留出的宽度
  final double textPadding; //刻度值和刻度的距离
  final double unit; //1mm对应的dp值，5dp对应1mm
  final Color lineColor; //1mm刻度颜色
  final Color line2Color; //5mm、10mm刻度颜色
  final Color indicationColor; //距离对比线颜色

  RulerWidget({
    this.lineWidth = 1,
    this.line1Width = 0.5,
    this.line1Height = 10,
    this.line2Height = 15,
    this.line3Height = 20,
    this.lineColor = Colors.black,
    this.line2Color = Colors.black87,
    this.indicationColor = Colors.redAccent,
    this.unit = 5.0,
    this.textPadding = 5,
    this.padding = 100,
  });

  @override
  State<StatefulWidget> createState() {
    return RulerState();
  }
}

class RulerState extends State<RulerWidget> {
  ValueNotifier<double> _dx = ValueNotifier(400);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTapDown: getDetailsDy,
        onPanUpdate: getDetailsDy,
        child: CustomPaint(
          size: MediaQuery.of(context).size,
          painter: RulerCustomPainter(widget, _dx),
        ),
      ),
    );
  }

  getDetailsDy(details) {
    if (details.globalPosition.dx <= widget.padding) {
      _dx.value = widget.padding;
    } else {
      _dx.value = details.globalPosition.dx;
    }
  }
}

class RulerCustomPainter extends CustomPainter {
  RulerWidget widget;
  ValueNotifier<double> dx;

  RulerCustomPainter(this.widget, this.dx) : super(repaint: dx);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.save();

    //绘制0点标准线
    canvas.drawLine(
      Offset(widget.padding, 0),
      Offset(widget.padding, size.height),
      Paint()
        ..color = widget.lineColor
        ..strokeWidth = 1,
    );
    //绘制对比线
    canvas.drawLine(
      Offset(dx.value, 0),
      Offset(dx.value, size.height),
      Paint()
        ..color = widget.indicationColor
        ..strokeWidth = 1,
    );

    canvas.restore();

    drawDimensionData(dx.value - widget.padding, canvas);

    //绘制尺子
    canvas.translate(widget.padding, 0);
    for (int i = 0; i <= ((size.width - widget.padding) / 5); i++) {
      if (i % 10 == 0) {
        /// 10的倍数绘制10mm刻度
        canvas.drawLine(
          Offset(i * widget.unit, 0),
          Offset(i * widget.unit, widget.line3Height),
          Paint()
            ..color = widget.line2Color
            ..strokeWidth = widget.lineWidth,
        );
        drawText(i, canvas);
      } else if (i % 5 == 0) {
        /// 5的倍数绘制5mm刻度
        canvas.drawLine(
          Offset(i * widget.unit, 0),
          Offset(i * widget.unit, widget.line2Height),
          Paint()
            ..color = widget.line2Color
            ..strokeWidth = widget.lineWidth,
        );
      } else {
        /// 绘制1mm刻度
        canvas.drawLine(
          Offset(i * widget.unit, 0),
          Offset(i * widget.unit, widget.line1Height),
          Paint()
            ..color = widget.lineColor
            ..strokeWidth = widget.line1Width,
        );
      }
    }
  }

  // 绘制当前数据 0.1968504
  void drawDimensionData(double dx, Canvas canvas) {
    double mm = dx / widget.unit;
    var mmPainter = TextPainter(
      text: TextSpan(
        text: '毫米(mm)：$mm',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    mmPainter.layout();
    mmPainter.paint(canvas, Offset(200, 100));

    double inValue = (dx / widget.unit) / 25.4;
    var inPainter = TextPainter(
      text: TextSpan(
        text: '英寸(in)：${inValue.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    inPainter.layout();
    inPainter.paint(canvas, Offset(200, 130));

    double ft = (dx / widget.unit) / 304.8;
    var ftPainter = TextPainter(
      text: TextSpan(
        text: '英尺(ft)：${ft.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    ftPainter.layout();
    ftPainter.paint(canvas, Offset(200, 160));

    double cun = (dx / widget.unit) / 33.333;
    var cunPainter = TextPainter(
      text: TextSpan(
        text: '寸：${cun.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    cunPainter.layout();
    cunPainter.paint(canvas, Offset(200, 190));

    double chi = (dx / widget.unit) / 333.333;
    var chiPainter = TextPainter(
      text: TextSpan(
        text: '尺：${chi.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    chiPainter.layout();
    chiPainter.paint(canvas, Offset(200, 220));
  }

  // 绘制刻度值
  void drawText(int i, Canvas canvas) {
    var textPainter = TextPainter(
      text: TextSpan(
        text: "$i",
        style: TextStyle(fontSize: 11, color: widget.lineColor),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas,
        Offset(i * widget.unit + 1, widget.line3Height + widget.textPadding));
  }

  @override
  bool shouldRepaint(RulerCustomPainter oldDelegate) {
    return dx != oldDelegate.dx;
  }
}
