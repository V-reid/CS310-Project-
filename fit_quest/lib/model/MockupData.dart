enum Difficulty { easy, medium, hard }

class MockupData {
  final String name;
  final double time;
  final Difficulty level;
  final double kcalBurn;
  final bool mostPopular;
  final String? image;
  final Map<String, String>? exercise;
  final Map<String, double>? rewards;

  const MockupData({
    required this.name,
    required this.time,
    required this.level,
    required this.kcalBurn,
    this.mostPopular = false,
    this.image,
    this.exercise,
    this.rewards,
  });
}
