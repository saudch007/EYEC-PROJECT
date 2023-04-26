class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Detect denomination on currency",
    image: "assets/images/image1.png",
    desc: "Remember to keep track of your professional accomplishments.",
  ),
  OnboardingContents(
    title: "Detect object in your radius",
    image: "",
    desc:
        "But understanding the contributions our colleagues make to our teams and companies.",
  ),
  OnboardingContents(
    title: "Detect product in your radius / optinal feature ",
    image: "",
    desc:
        "Take control of notifications, collaborate live or on your own time.",
  ),
];
