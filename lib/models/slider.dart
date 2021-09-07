import 'package:kitchen_ware_project/shared/constants.dart';

class Slider {
  final String? sliderImageUrl;
  final String? sliderHeading;
  final String? sliderSubHeading;
  final String? skipBtn;

  Slider(
      {this.sliderImageUrl,
      this.sliderHeading,
      this.sliderSubHeading,
      this.skipBtn});
}

final sliderArrayList = [
  Slider(
      sliderImageUrl: 'assets/images/slider_1.png',
      sliderHeading: Constants.SLIDER_HEADING_1,
      sliderSubHeading: Constants.SLIDER_DESC_1,
      skipBtn: Constants.SKIP),
  Slider(
      sliderImageUrl: 'assets/images/slider_2.png',
      sliderHeading: Constants.SLIDER_HEADING_2,
      sliderSubHeading: Constants.SLIDER_DESC_2,
      skipBtn: Constants.SKIP),
  Slider(
      sliderImageUrl: 'assets/images/slider_2.png',
      sliderHeading: Constants.SLIDER_HEADING_2,
      sliderSubHeading: Constants.SLIDER_DESC_2,
      skipBtn: Constants.SKIP),
];
