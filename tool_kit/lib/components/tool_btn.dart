import 'package:flutter/material.dart';
import 'package:tool_kit/utils/global.dart';

class ToolButton extends StatefulWidget {
  ToolButton({
    Key key,
    this.text,
    this.icon,
    this.onTap,
  }) : super(key: key);

  final Function onTap;
  final IconData icon;
  final String text;

  @override
  _ToolButtonState createState() => _ToolButtonState();
}

class _ToolButtonState extends State<ToolButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(20, 3, 20, 3),
        height: 70,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Global.backgroundColor.withOpacity(.3),
              width: .5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 20),
            Icon(
              widget.icon,
              color: Global.backgroundColor,
              size: 30,
            ),
            SizedBox(width: 20),
            Text(
              widget.text,
              style: TextStyle(
                color: Global.backgroundColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
