import 'package:fit_quest/common/common.dart';
import 'package:flutter/material.dart';

Widget imageWithOverlay({
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
