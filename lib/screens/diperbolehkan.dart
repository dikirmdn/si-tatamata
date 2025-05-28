import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiperbolehkanScreen extends StatelessWidget {
  const DiperbolehkanScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> poinDiperbolehkan = const [
    {
      'judul': 'Makanan',
      'deskripsi': 'Tidak ada larangan atau pantangan makan (kecuali ada larangan dari dokter spesialis lain.)',
      'icon': Icons.restaurant_menu,
      'color': Colors.green
    },
    {
      'judul': 'Membaca',
      'deskripsi': 'Diperbolehkan membaca, menonton, dan menunduk.',
      'icon': Icons.menu_book,
      'color': Colors.orange
    },
    {
      'judul': 'Istirahatkan Mata',
      'deskripsi': 'Istirahatkan mata bila merasa lelah, hindari memaksakan mata terus menerus',
      'icon': Icons.bedtime,
      'color': Colors.blue
    },
    {
      'judul': 'Membersihkan Mata',
      'deskripsi': 'Kotoran mata dapat dibersihkan dengan kassa/cotton bud dan air mengalir, usap lembut dari arah dalam (dekat hidung). Hindari menggosok mata terlalu keras',
      'icon': Icons.clean_hands,
      'color': Colors.purple
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Hal yang Diperbolehkan', 
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
                  'Berikut adalah hal-hal yang diperbolehkan setelah operasi mata:',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: poinDiperbolehkan.length,
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = poinDiperbolehkan[index];
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: (item['color'] as Color).withOpacity(0.13),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: item['color'] as Color,
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['judul']!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade800,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      item['deskripsi']!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.black87,
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