import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AturanPemakaianObatScreen extends StatelessWidget {
  AturanPemakaianObatScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> menuObat = [
    {
      'title': 'Tahapan Pemberian Obat',
      'icon': Icons.medical_services,
      'color': Colors.blue,
      'route': '/aturan/tahapan',
    },
    {
      'title': 'Tanda Bahaya Alergi Obat Tetes Mata',
      'icon': Icons.remove_red_eye,
      'color': Colors.orange,
      'route': '/aturan/alergi-tetes',
    },
    {
      'title': 'Tanda Bahaya Obat Tablet/pil',
      'icon': Icons.warning_amber_rounded,
      'color': Colors.red,
      'route': '/aturan/bahaya-tablet',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Aturan Pemakaian Obat', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade200,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SI-TATA MATA',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'ATURAN PEMAKAIAN OBAT',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Text(
                  'MENU',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 18),
                Expanded(
                  child: ListView.separated(
                    itemCount: menuObat.length,
                    separatorBuilder: (context, index) => SizedBox(height: 22),
                    itemBuilder: (context, index) {
                      final item = menuObat[index];
                      return TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: Duration(milliseconds: 400 + index * 100),
                        builder: (context, double value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 30 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            Navigator.pushNamed(context, item['route']);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.shade200.withOpacity(0.18),
                                  blurRadius: 16,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: item['color'].withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(14),
                                  child: Icon(
                                    item['icon'],
                                    color: item['color'],
                                    size: 34,
                                  ),
                                ),
                                SizedBox(width: 18),
                                Expanded(
                                  child: Text(
                                    item['title'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.red.shade400, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Hentikan penggunaan obat dan konsultasikan ke dokter mata atau dokter yang menangani operasi katarak dan bila terjadi kesulitan bernapas atau pembengkakan parah, segera ke UGD',
                          style: GoogleFonts.poppins(fontSize: 15, color: Colors.red.shade700, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 