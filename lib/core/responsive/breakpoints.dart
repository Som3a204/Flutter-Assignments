import 'package:flutter/material.dart';

class Breakpoints {
  Breakpoints._();
  
  static const double mobile = 600;
  static const double tablet = 900;
  
  /// Simple utility to check for Mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= mobile;
  }
  
  /// Simple utility to check for Tablet
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobile && 
           MediaQuery.of(context).size.width < tablet;
  }
  
  /// Simple utility to check for Desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tablet;
  }
}
