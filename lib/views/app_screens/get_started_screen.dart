import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/models/slider.dart';
import 'package:kitchen_ware_project/providers/app_provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/home_page.dart';
import 'package:kitchen_ware_project/widgets/slide_dots.dart';
import 'package:kitchen_ware_project/widgets/slider_item.dart';
import 'package:provider/provider.dart';


class GetStartedScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetStartedScreen();
}

class _GetStartedScreen extends State<GetStartedScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AppProvider>(context).setFirstUse(false);
  }


  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SliderLayout());
  }

  bool inFinalPage() {
    if (_currentPage == sliderArrayList.length - 1) {
      return true;
    }
    return false;
  }

  // ignore: non_constant_identifier_names
  Widget SliderLayout() => Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.only(
                right: 25.0, top: MediaQuery.of(context).size.width * 0.12),
            child: TextButton(
              style: TextButton.styleFrom(
                textStyle: TextStyle(fontSize: 14, color: LightOrangeColor),
              ),
              onPressed: () {
                MyRouter.pushPageReplacement(context, HomePage());
              },
              child: Text(
                "skip",
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
          ),
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: sliderArrayList.length,
              itemBuilder: (ctx, i) =>
                  inFinalPage() ? SlideItem(index: i, lastSlide: true) : SlideItem(index:i,lastSlide:false),
            ),
          ),
          Container(
            alignment: AlignmentDirectional.bottomCenter,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.06,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < sliderArrayList.length; i++)
                  if (i == _currentPage) SlideDots(true) else SlideDots(false)
              ],
            ),
          )
        ],
      );
}
