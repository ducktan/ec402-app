import 'package:ec402_app/features/authentication/screens/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ec402_app/features/authentication/controllers.onboarding/onboarding.controller.dart';
class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  void updatePageIndicator(index) => currentPageIndex.value = index;

  void dotNavigationClick(index) {
    currentPageIndex.value= index;
    pageController.jumpTo(index);
  }
  void nextPage() {
    if(currentPageIndex == 2){
      Get.offAll(const LoginScreen());
    } else {
      int page = currentPageIndex.value +1;
      pageController.jumpToPage(page);
    }
  }
  void skipPage() {
    currentPageIndex.value = 2 ;
    pageController.jumpToPage(2);
  }

}
