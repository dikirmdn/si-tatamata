import 'package:flutter/material.dart';
import 'screens/get_started.dart';
import 'screens/panduan_pasca_operasi.dart';
import 'screens/aturan_pemakaian_obat.dart';
import 'screens/tahapan_pemberian_obat.dart';
import 'screens/alergi_obat_tetes_mata.dart';
import 'screens/bahaya_obat_tablet.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(SitataMataApp());
}

class SitataMataApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SITATA MATA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: GetStartedScreen(),
      routes: {
        '/panduan': (context) => PanduanPascaOperasiScreen(),
        '/panduan/aturan-obat': (context) => AturanPemakaianObatScreen(),
        '/aturan/tahapan': (context) => TahapanPemberianObatScreen(),
        '/aturan/alergi-tetes': (context) => AlergiObatTetesMataScreen(),
        '/aturan/bahaya-tablet': (context) => BahayaObatTabletScreen(),
      },
    );
  }
}
