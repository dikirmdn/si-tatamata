import 'package:flutter/material.dart';
import 'screens/panduan_pasca_operasi.dart';
import 'screens/gejala_diwaspadai_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/panduan': (context) => PanduanPascaOperasiScreen(),
      '/panduan/gejala-diwaspadai': (context) => GejalaDiwaspadaiScreen(),
    };
  }
} 