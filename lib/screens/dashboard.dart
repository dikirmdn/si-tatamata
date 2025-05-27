import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'jadwal_kontrol_screen.dart';
import 'panduan_pasca_operasi.dart';
import 'jadwal_obat_screen.dart';
import 'catatan_harian_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = "Pengguna";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        
        if (userDoc.exists) {
          setState(() {
            userName = userDoc.get('nama') ?? "Pengguna";
          });
        }
      }
    } catch (e) {
      print("Error mengambil data pengguna: $e");
    }
  }

  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Panduan Pasca Operasi',
      'icon': Icons.menu_book,
      'route': '/panduan', // Placeholder
    },
    {
      'title': 'Jadwal Obat',
      'icon': Icons.access_alarm,
      'route': '/jadwal-obat',
    },
    {
      'title': 'Catatan Harian',
      'icon': Icons.note,
      'route': '/catatan-harian',
    },
    {
      'title': 'Jadwal Kontrol',
      'icon': Icons.calendar_today,
      'route': '/jadwal-kontrol',
    },
  ];

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat pagi';
    if (hour < 17) return 'Selamat siang';
    return 'Selamat malam';
  }

  @override
  Widget build(BuildContext context) {
    final greeting = getGreeting();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar custom
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting + ',',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blue.shade900),
                        ),
                        Text(
                          userName,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.blue.shade100,
                      child: IconButton(
                        icon: Icon(Icons.account_circle, size: 28, color: Colors.blue.shade700),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Banner info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade200],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade100,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Jaga kesehatan mata Anda dengan mengikuti panduan dan jadwal yang tersedia.',
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Grid menu
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    itemCount: menuItems.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      final item = menuItems[index];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.9, end: 1),
                        duration: Duration(milliseconds: 400 + index * 100),
                        curve: Curves.easeOutBack,
                        builder: (context, scale, child) {
                          return Transform.scale(
                            scale: scale,
                            child: child,
                          );
                        },
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            switch (item['route']) {
                              case '/jadwal-kontrol':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JadwalKontrolScreen(),
                                  ),
                                );
                                break;
                              case '/panduan':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PanduanPascaOperasiScreen(),
                                  ),
                                );
                                break;
                              case '/jadwal-obat':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JadwalObatScreen(),
                                  ),
                                );
                                break;
                              case '/catatan-harian':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CatatanHarianScreen(),
                                  ),
                                );
                                break;
                              default:
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Menu sedang dalam pengembangan")),
                                );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.blue.shade50],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.shade100.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: Offset(0, 6),
                                ),
                              ],
                              border: Border.all(color: Colors.blue.shade100),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [Colors.blue.shade200, Colors.blue.shade400],
                                    ),
                                  ),
                                  padding: EdgeInsets.all(14),
                                  child: Icon(item['icon'], size: 36, color: Colors.white),
                                ),
                                SizedBox(height: 14),
                                Text(
                                  item['title'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue.shade900,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
