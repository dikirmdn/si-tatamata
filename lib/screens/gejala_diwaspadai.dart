import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GejalaDiwaspadaiScreen extends StatelessWidget {
  final List<Map<String, dynamic>> gejalaList = [
    {
      'title': 'Nyeri Berat',
      'description': 'Nyeri mata yang hebat atau terus menerus',
      'image': 'assets/images/nyeri.png',
      'level': 'Waspada',
    },
    {
      'title': 'Penglihatan Menurun',
      'description': 'Penglihatan tiba-tiba kabur',
      'image': 'assets/images/kabur.png',
      'level': 'Waspada',
    },
    {
      'title': 'Keluar Cairan',
      'description': 'Keluar cairan atau nanah dari mata',
      'image': 'assets/images/berair.png',
      'level': 'Waspada',
    },
    {
      'title': 'Sensasi Benda Asing',
      'description': 'Sensasi ada benda asing yang sangat mengganggu',
      'image': 'assets/images/benda-asing.png',
      'level': 'Waspada',
    },
    {
      'title': 'Bengkak',
      'description': 'Bengkak yang tidak normal',
      'image': 'assets/images/bengkak.png',
      'level': 'Waspada',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Gejala yang Diwaspadai', 
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)
        ),
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
                Text(
                  'SEGERA HUBUNGI DOKTER JIKA MENGALAMI:',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: gejalaList.length,
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final gejala = gejalaList[index];
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
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
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
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: gejala['level'] == 'Kritis' 
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(
                                  gejala['image'],
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            gejala['title'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: gejala['level'] == 'Kritis'
                                                ? Colors.red.withOpacity(0.1)
                                                : Colors.orange.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            gejala['level'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: gejala['level'] == 'Kritis'
                                                  ? Colors.red
                                                  : Colors.orange,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      gejala['description'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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