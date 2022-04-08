import 'package:flutter/material.dart';

class DescriptionPageNotifier with ChangeNotifier {
  double _offset = 0;
  double _page = 0;

  double get offset => _offset;
  double get page => _page;

  DescriptionPageNotifier(PageController pageController) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = pageController.page ?? 0;
      notifyListeners();
    });
  }

  reset() {
    _offset = 0;
    _page = 0;
  }
}