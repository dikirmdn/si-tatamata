import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/get_started.dart';
import 'screens/panduan_pasca_operasi.dart';
import 'screens/aturan_pemakaian_obat.dart';
import 'screens/tahapan_pemberian_obat.dart';
import 'screens/alergi_obat_tetes_mata.dart';
import 'screens/bahaya_obat_tablet.dart';
import 'screens/wajib_dipatuhi.dart';
import 'screens/diperbolehkan.dart';
import 'screens/gejala_diwaspadai.dart';
import 'screens/dashboard.dart';
import 'screens/jadwal_kontrol_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simata/screens/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase berhasil diinisialisasi');
  } catch (e) {
    print('Error inisialisasi Firebase: $e');
  }
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
        '/panduan/wajib-dipatuhi': (context) => WajibDipatuhiScreen(),
        '/aturan/tahapan': (context) => TahapanPemberianObatScreen(),
        '/aturan/alergi-tetes': (context) => AlergiObatTetesMataScreen(),
        '/aturan/bahaya-tablet': (context) => BahayaObatTabletScreen(),
        '/panduan/diperbolehkan': (context) => DiperbolehkanScreen(),
        '/panduan/gejala-diwaspadai': (context) => GejalaDiwaspadaiScreen(),
        '/jadwal-kontrol': (context) => JadwalKontrolScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}
