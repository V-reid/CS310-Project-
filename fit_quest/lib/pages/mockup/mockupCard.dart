import 'package:fit_quest/common/common.dart';
import 'package:fit_quest/model/user.dart';
import 'package:fit_quest/pages/mockup/components.dart';
import 'package:flutter/material.dart';

enum Difficulty { easy, medium, hard }

Widget levelIcons(Difficulty level) {
  int num =
      level == Difficulty.hard
          ? 3
          : level == Difficulty.medium
          ? 2
          : 1;

  return Row(
    children:
        [num >= 1, num >= 2, num >= 3]
            .map(
              (x) => Icon(x ? Icons.circle : Icons.panorama_fish_eye, size: 16),
            )
            .toList(),
  );
}

String format(int num) {
  return num == 0
      ? "00"
      : num < 10
      ? "0$num"
      : "$num";
}

String doubleToTimeString(double time) {
  int sec = ((time % 1) * 100 * 60 / 100).floor();
  int hour = (time / 60).floor();
  int minutes = (time - hour * 60).floor();

  return "${format(hour)}:${format(minutes)}:${format(sec)}";
}

class MockupCard extends StatelessWidget {
  const MockupCard({
    super.key,
    required this.name,
    required this.time,
    required this.level,
    required this.kcalBurn,
    this.mostPopular = false,
    this.exercise,
    this.rewards,
    this.image,
  });

  final String name;
  final double time;
  final Difficulty level;
  final double kcalBurn;
  final bool mostPopular;
  final String? image;
  final Map<String, String>? exercise;
  final Map<PhysicalAbility, double>? rewards;

  final double width = 350;
  final double height = 125;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,

      // padding: UI.customPadding(10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: UI.accent,
        boxShadow: [
          mostPopular
              ? UI.boxShadow(
                spread: 3,
                blur: 0,
                color: UI.primary.withValues(alpha: 1),
                offset: Offset(0, 0),
              )
              : BoxShadow(),
          UI.boxShadow(),
        ],
        borderRadius: UI.borderRadius,
      ),
      child: Row(
        children: [
          image != null
              ? imageWithOverlay(
                width: width / 1.8,
                height: height,
                image: AssetImage(image!),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    mostPopular
                        ? Container(
                          padding: UI.padx(5),
                          decoration: BoxDecoration(
                            color: UI.primary,
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                          child: Common.text(
                            data: "Most Popular",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        )
                        : Container(),

                    Common.paddingContainer(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon(
                          //   Icons.trending_up_rounded,
                          //   size: 35,
                          //   color: UI.primary,
                          // ),
                          Common.title(data: name, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              : Container(),
          Common.paddingContainer(
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    Icon(Icons.watch_later),
                    Common.text(data: doubleToTimeString(time), fontSize: 12),
                  ],
                ),
                Row(
                  spacing: 5,
                  children: [Icon(Icons.fitness_center), levelIcons(level)],
                ),
                Row(
                  spacing: 5,
                  children: [
                    Icon(Icons.whatshot),
                    Column(
                      children: [
                        Common.text(data: "${kcalBurn.floor()} ", fontSize: 12),
                        Common.text(data: "kcal", fontSize: 10),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'time': time,
    'level': level.name,
    'kcalBurn': kcalBurn,
    'image': image,
    'mostPopular': mostPopular,
    'exercise': exercise,
    'rewards': rewards?.map((k, v) => MapEntry(k.name, v)),
  };

  static Map<PhysicalAbility, double>? rewardsFromJson(
  Map<String, dynamic>? json,
) {
  if (json == null) return null;

  return json.map<PhysicalAbility, double>((key, value) {
    final ability = PhysicalAbility.values.firstWhere(
      (e) => e.name.toLowerCase() == key.toLowerCase(),
      orElse: () => throw FormatException('Invalid ability: $key'),
    );

    // Ensure value is double
    double parsedValue;
    if (value is double) {
      parsedValue = value;
    } else if (value is int) {
      parsedValue = value.toDouble();
    } else if (value is String) {
      parsedValue = double.tryParse(value) ?? 0.0;
    } else {
      throw FormatException("Unsupported type for reward value: $value");
    }

    return MapEntry(ability, parsedValue);
  });
}

  // static Map<PhysicalAbility, double>? rewardsFromJson(
  //   Map<String, dynamic>? json,
  // ) {
  //   print(json);
  //   if (json == null) return null;

  //   return json.map<PhysicalAbility, double>((key, value) {
  //     final ability = PhysicalAbility.values.firstWhere(
  //       (e) => e.name.toLowerCase() == key.toLowerCase(),
  //       orElse: () => throw FormatException('Invalid ability: $key'),
  //     );

  //     return MapEntry(ability, double.parse(value));
  //   });
  // }

  static MockupCard fromJson(Map<String, dynamic> json) => MockupCard(
    name: json['name'],
    time: (json['time'] as num).toDouble(),
    level: Difficulty.values.byName(json['level']),
    kcalBurn: json['kcalBurn'],
    image: json['image'],
    mostPopular: json['mostPopular'] ?? false,
    exercise: Map<String, String>.from(json['exercise']),
    rewards: rewardsFromJson(json["rewards"]),
  );
}
