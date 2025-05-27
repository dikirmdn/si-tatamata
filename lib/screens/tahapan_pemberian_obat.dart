import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TahapanPemberianObatScreen extends StatelessWidget {
  const TahapanPemberianObatScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> tahapan = const [
    {
      'judul': '1. Cuci Tangan',
      'deskripsi': 'Cuci tangan dengan sabun dan air.',
      'icon': Icons.clean_hands,
      'color': Colors.blue
    },
    {
      'judul': '2. Posisi Tubuh dan Kepala',
      'deskripsi': 'Berdiri atau duduk dengan tegak, posisi kepala mendongak sampai wajah mengarah ke langit-langit.',
      'icon': Icons.accessibility_new,
      'color': Colors.teal
    },
    {
      'judul': '3. Tarik Kantong Mata',
      'deskripsi': 'Tarik kantong mata ke bawah dengan jari telunjuk.',
      'icon': Icons.pan_tool_alt,
      'color': Colors.orange
    },
    {
      'judul': '4. Teteskan Obat',
      'deskripsi': 'Teteskan obat mata ke dalam kantong mata.',
      'icon': Icons.medical_services,
      'color': Colors.purple
    },
    {
      'judul': '5. Tutup Mata',
      'deskripsi': 'Tutup mata selama 2 - 3 menit, jangan berkedip.',
      'icon': Icons.remove_red_eye,
      'color': Colors.indigo
    },
    {
      'judul': '6. Dua Tetes',
      'deskripsi': 'Jika harus pakai dua tetes, tunggu 5 menit dulu sebelum tetesan kedua.',
      'icon': Icons.timer,
      'color': Colors.red
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tahapan Pemberian Obat', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.blue.shade800),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ikuti langkah-langkah berikut untuk meneteskan obat mata dengan benar:',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 18),
                Expanded(
                  child: ListView.separated(
                    itemCount: tahapan.length,
                    separatorBuilder: (context, index) => SizedBox(height: 18),
                    itemBuilder: (context, index) {
                      final item = tahapan[index];
                      return Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.blue.shade100, width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade100.withOpacity(0.10),
                                blurRadius: 12,
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