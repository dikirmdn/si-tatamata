import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WajibDipatuhiScreen extends StatelessWidget {
  const WajibDipatuhiScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> poinWajib = const [
    {
      'judul': 'Jangan Mencuci Area Mata',
      'deskripsi': 'Dilarang mencuci area mata selama 1 minggu setelah operasi.',
      'icon': Icons.visibility_off,
      'color': Colors.red
    },
    {
      'judul': 'Jangan Mengangkat Beban',
      'deskripsi': 'Dilarang mengangkat benda di atas 5KG.',
      'icon': Icons.fitness_center,
      'color': Colors.blue
    },
    {
      'judul': 'Jangan Melakukan Gerakan Hentakan',
      'deskripsi': 'Dilarang melakukan gerakan hentakan.',
      'icon': Icons.directions_run,
      'color': Colors.green
    },
    {
      'judul': 'Jangan Berpergian dengan Kendaraan Terbuka',
      'deskripsi': 'Dilarang berpergian dengan kendaraan terbuka.',
      'icon': Icons.motorcycle,
      'color': Colors.purple
    },
    {
      'judul': 'Jangan menggunakan kaos',
      'deskripsi': 'Dilarang menggunakan baju kaos selama 1 Minggu',
      'icon': Icons.checkroom,
      'color': Colors.orange
    },
    {
      'judul': 'Kacamata Pelindung',
      'deskripsi': 'Selalu gunakan kacamata pelindung',
      'icon': Icons.remove_red_eye,
      'color': Colors.teal
    },
    {
      'judul': 'Hindari',
      'deskripsi': 'Hindari mata dari asap, debu, dan kotoran',
      'icon': Icons.warning_amber_rounded,
      'color': Colors.teal
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Hal yang Wajib Dipatuhi', 
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
                  'Berikut adalah hal-hal yang wajib dipatuhi setelah operasi mata:',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: poinWajib.length,
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = poinWajib[index];
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