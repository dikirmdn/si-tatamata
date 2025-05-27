import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BahayaObatTabletScreen extends StatelessWidget {
  const BahayaObatTabletScreen({Key? key}) : super(key: key);

  final List<String> tandaBahaya = const [
    'Ruam kulit atau gatal-gatal setelah minum obat.',
    'Bengkak pada wajah, bibir, lidah, atau tenggorokan.',
    'Kesulitan bernapas atau sesak napas.',
    'Mual, muntah hebat, atau diare terus-menerus.',
    'Pusing berat atau pingsan.',
    'Detak jantung tidak teratur atau berdebar hebat.',
    'Mata atau kulit menguning (tanda gangguan hati).',
    'Keluar darah pada urine atau tinja.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tanda Bahaya Obat Tablet/Pil', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
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
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14),
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200, width: 1.2),
                  ),
                  child: Text(
                    'Kenali tanda-tanda bahaya berikut setelah mengonsumsi obat tablet/pil:',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue.shade900),
                  ),
                ),
                SizedBox(height: 18),
                Expanded(
                  child: ListView.separated(
                    itemCount: tandaBahaya.length,
                    separatorBuilder: (context, index) => SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade200.withOpacity(0.15),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.red.shade400, size: 28),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tandaBahaya[index],
                                style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
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
                      Icon(Icons.local_hospital, color: Colors.red.shade400, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Jika mengalami tanda-tanda di atas, segera hentikan penggunaan obat dan konsultasikan ke dokter mata atau ke UGD terdekat.',
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