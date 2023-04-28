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
    title: "Detect currency denomination",
    image: "assets/images/image1.png",
    desc: "You can detect denomination on an Pakistani currency note.",
  ),
  OnboardingContents(
    title: "Detect object in your radius",
    image: "assets/images/image2.png",
    desc: "You can detect objects by using phone camera.",
  ),
  OnboardingContents(
    title: "Detect product in your radius / optinal feature ",
    image: "assets/images/image3.png",
    desc: "You can detect products by using phone camera.",
  ),
];
