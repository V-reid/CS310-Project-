import 'package:flutter/material.dart';

class Padding {
  static const small = EdgeInsets.all(10);
  static const medium = EdgeInsets.all(20);
  static const large = EdgeInsets.all(30);
}

class UI {
  static const Color primary = Colors.orange;
  static const Color secondary = Colors.black38;
  static const Color accent = Color.fromARGB(255, 214, 214, 214);
  static const Color background = Colors.white;

  static const BorderRadiusGeometry borderRadius = BorderRadius.all(
    Radius.circular(20),
  );

  static const Map<String, EdgeInsets> padding = {
    "small": EdgeInsets.all(10),
    "medium": EdgeInsets.all(20),
    "large": EdgeInsets.all(30),
  };
  static EdgeInsets customPadding(double val) => EdgeInsets.all(val);
  static EdgeInsets padx(double val) => EdgeInsets.fromLTRB(val, 0, val, 0);
  static EdgeInsets pady(double val) => EdgeInsets.fromLTRB(0, val, 0, val);
  static EdgeInsets padxy(double x, double y) =>
      EdgeInsets.fromLTRB(x, y, x, y);
}

class Common {
  static AppBar appBar(String title) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container(height: 3, width: 20, color: Colors.black)),
          Center(child: Common.title(data: title, fontSize: 18)),
          Expanded(child: Container(height: 3, width: 20, color: Colors.black)),
        ],
      ),
    );
  }

  static Widget imageWithOverlay({
    required double width,
    required double height,
    required ImageProvider<Object> image,
    Color overlayColor = Colors.black38,
    BoxFit fit = BoxFit.cover,
    BorderRadiusGeometry borderRadius = UI.borderRadius,
    BlendMode blend = BlendMode.darken,
    Widget? child,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: fit,
          colorFilter: ColorFilter.mode(overlayColor, blend),
        ),
        borderRadius: borderRadius,
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: child,
    );
  }

  static Widget title({
    required String data,
    FontWeight weight = FontWeight.bold,
    double fontSize = 14,
    Color color = Colors.black,
    TextOverflow? overflow,
  }) {
    return Text(
      data,
      style: TextStyle(
        overflow: overflow,
        fontWeight: weight,
        fontSize: fontSize,
        color: color,
        fontFamily: "Pokemon",
      ),
    );
  }

  static Widget text({
    required String data,
    FontWeight weight = FontWeight.normal,
    double? fontSize,
    Color color = Colors.black,
    String? fontFamily = "Pokemon",
    TextOverflow? overflow,
  }) {
    return Text(
      data,
      style: TextStyle(
        fontWeight: weight,
        overflow: overflow,
        fontSize: fontSize,
        color: color,
        fontFamily: fontFamily,
      ),
    );
  }

  static boxShadow({
    Color? color,
    double spread = 5,
    double blur = 7,
    Offset? offset,
  }) {
    return BoxShadow(
      color: color ?? Colors.grey.withValues(alpha: 0.5),
      spreadRadius: spread,
      blurRadius: blur,
      offset: offset ?? Offset(0, 3), // changes position of shadow
    );
  }

  static ElevatedButton elevatedButton(String str, void Function()? f) {
    return ElevatedButton(onPressed: f, child: Text(str));
  }

  static paddingContainer(Widget child) {
    return Container(padding: UI.customPadding(10), child: child);
  }
}
