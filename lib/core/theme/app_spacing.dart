import 'package:flutter/material.dart';

class AppSpacing {
  //resuable 
  //ios, android, web
  

  AppSpacing._();
  
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppRadius {
  AppRadius._();
  
  static final BorderRadius sm = BorderRadius.circular(4);
  static final BorderRadius card = BorderRadius.circular(8);
  static final BorderRadius lg = BorderRadius.circular(16);
  static final BorderRadius round = BorderRadius.circular(50);
}
