import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class PanduanPascaOperasiScreen extends StatelessWidget {
  final List<Map<String, dynamic>> menuPanduan = [
    {
      'title': 'Aturan Pemakaian Obat',
      'icon': Icons.medical_services,
      'route': '/panduan/aturan-obat',
      'label': 'Wajib',
    },
    {
      'title': 'Hal yang Wajib Di Patuhi',
      'icon': Icons.warning_amber_rounded,
      'route': '/panduan/wajib-dipatuhi',
      'label': 'Penting',
    },
    {
      'title': 'Hal yang Di Perbolehkan',
      'icon': Icons.check_box,
      'route': '/panduan/diperbolehkan',
      'label': '',
    },
    {
      'title': 'Gejala Yang Diwaspadai',
      'icon': Icons.phone,
      'route': '/panduan/gejala-diwaspadai',
      'label': 'Awas',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Panduan Pasca Operasi', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22)),
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
                    // Logo
                    Container(
                      width: 90,
                      height: 90,
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
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    // Judul dan ilustrasi
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SI-TATA MATA',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'SISTEM INFORMASI TATALAKSANA MATA',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Ilustrasi dekoratif (bisa diganti asset lain)
                   
                  ],
                ),
                SizedBox(height: 32),
                Text(
                  'PANDUAN PASCA OPERASI',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                // Animated ListView
                Expanded(
                  child: ListView.separated(
                    itemCount: menuPanduan.length,
                    separatorBuilder: (context, index) => SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      final item = menuPanduan[index];
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Nomor bulat biru
                            Column(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.shade200.withOpacity(0.5),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: GoogleFonts.poppins(
                                        color: Color(0xFF2575fc),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                if (index < menuPanduan.length - 1)
                                  Container(
                                    width: 4,
                                    height: 40,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                              ],
                            ),
                            SizedBox(width: 18),
                            // Ikon dan judul
                            Expanded(
                              child: GestureDetector(
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
                                          color: Color(0xFF2575fc).withOpacity(0.12),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: EdgeInsets.all(14),
                                        child: Icon(
                                          item['icon'],
                                          color: Color(0xFF2575fc),
                                          size: 34,
                                        ),
                                      ),
                                      SizedBox(width: 18),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['title'],
                                              style: GoogleFonts.poppins(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            if (item['label'] != null && item['label'] != '')
                                              Container(
                                                margin: EdgeInsets.only(top: 4),
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: item['label'] == 'Awas'
                                                      ? Colors.red.withOpacity(0.08)
                                                      : Color(0xFF2575fc).withOpacity(0.08),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  item['label'],
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    color: item['label'] == 'Awas' ? Colors.red : Color(0xFF2575fc),
                                                    fontWeight: FontWeight.w600,
                                                  ),
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
                          ],
                        ),
                      );
                    },
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