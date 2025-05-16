import 'package:flutter/material.dart';

class PaddingConst {
  static const small = EdgeInsets.all(10);
  static const medium = EdgeInsets.all(20);
  static const large = EdgeInsets.all(30);
}

class UI {
  static const Color primary = Colors.orange;
  static const Color secondary = Colors.black38;
  static const Color accent = Color.fromARGB(255, 214, 214, 214);
  static const Color background = Colors.white;
  static const Color walkCardColor = Colors.cyanAccent;
  static const Color activeTimeCardColor = Colors.yellowAccent;
  static const Color questProgressCardColor = Colors.purpleAccent;

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

  static Widget progressBarWithText({
    required double current,
    required double max,
    String unit = '',
  }) {
    double percentage = (current / max).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        double barWidth = constraints.maxWidth * percentage;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Background bar
            Container(
              height: 20,
              width: constraints.maxWidth, // match parent
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Green progress bar
            Positioned(
              left: 0,
              child: Container(
                height: 20,
                width: barWidth, // dynamically calculated
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // Centered text
            Common.text(
              data: "$current/$max $unit",
              fontWeight: FontWeight.w100,
            ),
          ],
        );
      },
    );
  }
  // static Widget progressBar({
  //   required double current,
  //   required double max,
  //   double? width,
  //   double? height,
  //   Color background = UI.accent,
  //   Color fill = Colors.lightGreen,
  //   bool withText = true,
  //   double right = 45,
  // }) {
  //   double perc = current / max * (width ?? 1);
  //   String health = "${current.toInt()}/${max.toInt()}";
  //   double minHeight = height == null || height > 16 ? 16 : height;
  //   return Container(
  //     decoration: BoxDecoration(borderRadius: UI.borderRadius),
  //     clipBehavior: Clip.hardEdge,
  //     child: Stack(
  //       children: [
  //         Container(width: width, height: height, color: background),
  //         Container(width: perc, height: height, color: fill),
  //         withText
  //             ? Positioned(
  //               right: right,
  //               child: Common.text(
  //                 data: health,
  //                 fontSize: minHeight,
  //                 textAlign: TextAlign.center,
  //               ),
  //             )
  //             : Container(),
  //       ],
  //     ),
  //   );
  // }

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

  static List<String> days = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];
  static Widget dayButton({
    required String text,
    void Function()? onTap,
    bool isToday = false,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: UI.padxy(10, 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : UI.accent,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color:
                isToday
                    ? Colors.red
                    : (isSelected ? Colors.black : Colors.transparent),
            width: isToday || isSelected ? 2 : 0,
          ),
        ),
        child: Center(
          child: Common.text(
            data: text,
            color: Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  static Widget text({
    required String data,
    FontWeight fontWeight = FontWeight.normal,
    double? fontSize,
    Color color = Colors.black,
    String? fontFamily = "Pokemon",
    TextOverflow? overflow,
    TextAlign textAlign = TextAlign.center,
  }) {
    return Text(
      data,
      textAlign: textAlign,
      style: TextStyle(
        fontWeight: fontWeight,
        overflow: overflow,
        fontSize: fontSize,
        color: color,
        fontFamily: fontFamily,
      ),
    );
  }

  static ElevatedButton elevatedButton(String str, void Function()? f) {
    return ElevatedButton(onPressed: f, child: Common.text(data: str));
  }

  static paddingContainer(Widget child) {
    return Container(padding: UI.customPadding(10), child: child);
  }
}

class CustomProgressBar extends StatelessWidget {
  final double current;
  final double max;
  final double width;
  final double height;
  final double radius;
  final Color fillColor;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final bool showText;
  final Widget Function(double current, double max, double percentage)?
  textBuilder;

  const CustomProgressBar({
    super.key,
    required this.current,
    required this.max,
    this.width = 200.0,
    this.height = 20.0,
    this.radius = 50.0,
    this.fillColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.textStyle,
    this.showText = true,
    this.textBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final clampedValue = current.clamp(0, max).toDouble();
    final percentage = max > 0 ? (clampedValue / max) : 0.0;
    final text =
        textBuilder != null
            ? textBuilder!(clampedValue, max, percentage)
            : _buildProgressText(clampedValue, max, percentage);

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height,
            constraints: BoxConstraints(maxWidth: width),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: width * percentage,
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(radius),
                  ),
                ),
                if (showText) Positioned.fill(child: Center(child: text)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressText(double current, double max, double percentage) {
    return Text(
      '${current.toStringAsFixed(0)}/${max.toStringAsFixed(0)} ',
      // '(${(percentage * 100).toStringAsFixed(1)}%)',
      style:
          textStyle ??
          TextStyle(
            color: _getContrastColor(fillColor),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Color _getContrastColor(Color color) {
    final brightness = color.computeLuminance();
    return brightness > 0.5 ? Colors.black : Colors.white;
  }
}
