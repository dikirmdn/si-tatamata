import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TahapanPemberianObatScreen extends StatelessWidget {
  const TahapanPemberianObatScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> tahapan = const [
    {
      'judul': '1. Cuci Tangan',
      'deskripsi': 'Cuci tangan dengan sabun dan air.',
      'icon': Icons.clean_hands,
      'color': const Color(0xFF1565C0) // blue.shade800
    },
    {
      'judul': '2. Posisi Tubuh dan Kepala',
      'deskripsi': 'Berdiri atau duduk dengan tegak, posisi kepala mendongak sampai wajah mengarah ke langit-langit.',
      'icon': Icons.accessibility_new,
      'color': const Color(0xFF1976D2) // blue.shade700
    },
    {
      'judul': '3. Tarik Kantong Mata',
      'deskripsi': 'Tarik kantong mata ke bawah dengan jari telunjuk.',
      'icon': Icons.pan_tool_alt,
      'color': const Color(0xFF1E88E5) // blue.shade600
    },
    {
      'judul': '4. Teteskan Obat',
      'deskripsi': 'Teteskan obat mata ke dalam kantong mata.',
      'icon': Icons.medical_services,
      'color': const Color(0xFF2196F3) // blue.shade500
    },
    {
      'judul': '5. Tutup Mata',
      'deskripsi': 'Tutup mata selama 2 - 3 menit, jangan berkedip.',
      'icon': Icons.remove_red_eye,
      'color': const Color(0xFF42A5F5) // blue.shade400
    },
    {
      'judul': '6. Dua Tetes',
      'deskripsi': 'Jika harus pakai dua tetes, tunggu 5 menit dulu sebelum tetesan kedua.',
      'icon': Icons.timer,
      'color': const Color(0xFF64B5F6) // blue.shade300
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Tahapan Pemberian Obat', 
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: const [
              Color(0xFF1565C0), // blue.shade800
              Color(0xFF64B5F6), // blue.shade300
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
                  'Ikuti langkah-langkah berikut untuk meneteskan obat mata dengan benar:',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: tahapan.length,
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = tahapan[index];
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
                                color: const Color(0xFF64B5F6).withOpacity(0.18), // blue.shade300
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
                                        color: const Color(0xFF1565C0), // blue.shade800
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