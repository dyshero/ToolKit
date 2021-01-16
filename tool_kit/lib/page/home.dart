import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tool_kit/components/tool_btn.dart';
import 'package:tool_kit/utils/global.dart';
import 'package:tool_kit/utils/icon_font.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double boxHeight = 35;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Global.primaryColor, Global.primaryColor.withOpacity(.4)],
      )),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Container(
                width: 100,
                child: Image.asset("assets/images/icon.png"),
              ),
              SizedBox(height: boxHeight),
              ToolButton(
                icon: IconFont.erweima,
                text: '二维码',
                onTap: () {},
              ),
              SizedBox(height: boxHeight),
              ToolButton(
                icon: IconFont.chizi,
                text: '尺子',
                onTap: () {},
              ),
              SizedBox(height: boxHeight),
              ToolButton(
                icon: IconFont.jiami,
                text: '加密',
                onTap: () {},
              ),
              SizedBox(height: boxHeight),
              ToolButton(
                icon: IconFont.zhuanhuan,
                text: '转换',
                onTap: () {},
              ),
              SizedBox(height: boxHeight),
            ]),
      ),
    ));
  }
}
