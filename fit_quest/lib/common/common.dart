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

  static Widget sectionName({
    required String title,
    List<int> flexs = const [0, 4, 10],
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: flexs[0],
          child: Container(height: 3, width: 20, color: Colors.black),
        ),
        Expanded(
          flex: flexs[1],
          child: Center(child: Common.title(data: title, fontSize: 16)),
        ),
        Expanded(
          flex: flexs[2],
          child: Container(height: 3, width: 20, color: Colors.black),
        ),
      ],
    );
  }

  static Widget progressBar({
    required double current,
    required double max,
    double? width,
    double? height,
    Color background = UI.accent,
    Color fill = Colors.lightGreen,
    bool withText = true,
    double right = 50,
  }) {
    double perc = current / max * (width ?? 1);
    String health = "${current.toInt()}/${max.toInt()}";
    double minHeight = height == null || height > 16 ? 16 : height;
    return Container(
      decoration: BoxDecoration(borderRadius: UI.borderRadius),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Container(width: width, height: height, color: background),
          Container(width: perc, height: height, color: fill),
          withText
              ? Positioned(
                right: right,
                child: Text(
                  health,
                  style: TextStyle(fontSize: minHeight),
                  textAlign: TextAlign.center,
                ),
              )
              : Container(),
        ],
      ),
    );
  }

  static Widget Grid<T>({
    required List<T> items,
    required Widget toElement(T),
    int col = 2,
    double spacing = 20,
  }) {
    return Column(
      spacing: 20,
      children: [
        for (int i = 0; i <= items.length; i += col)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: spacing,
            children:
                items
                    .where(
                      (x) =>
                          items.indexOf(x) >= i &&
                          items.indexOf(x) <= i + (col - 1),
                    )
                    .map(toElement)
                    .toList(),
          ),
      ],
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

  static List<String> days = ["M", "Tu", "W", "Th", "F", "Sa", "Su"];
  static Widget dayButton({required String text, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // width: 30,
        padding: UI.padxy(10, 5),
        // color: UI.accent,
        decoration: BoxDecoration(
          color: UI.accent,

          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),

        child: Center(child: Text(text, style: TextStyle(color: Colors.black))),
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

  static ElevatedButton elevatedButton(String str, void Function()? f) {
    return ElevatedButton(onPressed: f, child: Text(str));
  }

  static paddingContainer(Widget child) {
    return Container(padding: UI.customPadding(10), child: child);
  }
}
