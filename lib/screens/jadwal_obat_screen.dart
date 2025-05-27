import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/notification_service.dart';

class JadwalObatScreen extends StatefulWidget {
  const JadwalObatScreen({Key? key}) : super(key: key);

  @override
  State<JadwalObatScreen> createState() => _JadwalObatScreenState();
}

class _JadwalObatScreenState extends State<JadwalObatScreen> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationService _notificationService = NotificationService();
  final TextEditingController _namaObatController = TextEditingController();
  final TextEditingController _sediaanManualController = TextEditingController();
  final TextEditingController _durasiManualController = TextEditingController();
  TimeOfDay _waktuMinum = TimeOfDay.now();
  List<TimeOfDay> _waktuMinumList = [];
  bool _isLoading = false;
  bool _showForm = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // List sediaan obat
  final List<String> _sediaanList = [
    'Sediaan Obat/Jenis',
    'Tablet/Pill',
    'Drops/Tetes',
    'Solution/Salep',
    'Lain-Lain'
  ];
  String _selectedSediaan = 'Sediaan Obat/Jenis';
  bool _showSediaanManual = false;

  // List frekuensi minum
  final List<String> _frekuensiList = [
    'Frekuensi Pemakaian',
    'Sekali Sehari',
    'Dua Kali Sehari',
    'Tiga Kali Sehari'
  ];
  String? _selectedFrekuensi;

  // List waktu makan
  final List<String> _waktuMakanList = [
    'Waktu Makan',
    'Sebelum Makan',
    'Sesudah Makan',
    'Sambil Makan',
    'Tidak Masalah'
  ];
  String? _selectedWaktuMakan;

  // List durasi minum
  final List<String> _durasiList = [
    'Durasi Pemakaian',
    '3 hari',
    '5 hari',
    '1 minggu',
    'Lain-lain'
  ];
  String? _selectedDurasi;
  bool _showDurasiManual = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
  }

  Future<void> _scheduleNotifications(String docId, String namaObat, List<TimeOfDay> waktuMinum) async {
    final now = DateTime.now();
    
    for (int i = 0; i < waktuMinum.length; i++) {
      final time = waktuMinum[i];
      var scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
      
      // Jika waktu sudah lewat hari ini, jadwalkan untuk besok
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(Duration(days: 1));
      }

      // Buat ID unik untuk setiap notifikasi
      final notificationId = int.parse('${docId.hashCode}${i}');
      
      await _notificationService.scheduleNotification(
        id: notificationId,
        title: 'Pengingat Minum Obat',
        body: 'Waktunya minum $namaObat pada pukul ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
        scheduledTime: scheduledTime,
      );
    }
  }

  @override
  void dispose() {
    _namaObatController.dispose();
    _sediaanManualController.dispose();
    _durasiManualController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Fungsi untuk menghitung waktu minum berdasarkan frekuensi
  void _hitungWaktuMinum(TimeOfDay waktuPertama) {
    setState(() {
      _waktuMinumList = [];
      _waktuMinumList.add(waktuPertama);

      if (_selectedFrekuensi == 'Dua Kali Sehari') {
        // Tambah 12 jam
        int jam = (waktuPertama.hour + 12) % 24;
        _waktuMinumList.add(TimeOfDay(hour: jam, minute: waktuPertama.minute));
      } else if (_selectedFrekuensi == 'Tiga Kali Sehari') {
        // Tambah 8 jam untuk waktu kedua
        int jam1 = (waktuPertama.hour + 8) % 24;
        _waktuMinumList.add(TimeOfDay(hour: jam1, minute: waktuPertama.minute));
        
        // Tambah 8 jam lagi untuk waktu ketiga
        int jam2 = (jam1 + 8) % 24;
        _waktuMinumList.add(TimeOfDay(hour: jam2, minute: waktuPertama.minute));
      }
    });
  }

  Future<void> _pilihWaktu() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _waktuMinum,
    );
    if (picked != null && picked != _waktuMinum) {
      setState(() {
        _waktuMinum = picked;
      });
      _hitungWaktuMinum(picked);
    }
  }

  Future<void> _tambahJadwalObat() async {
    if (_namaObatController.text.isEmpty || 
        _selectedFrekuensi == null ||
        _selectedWaktuMakan == null ||
        _selectedDurasi == null ||
        (_selectedSediaan == 'Lain-Lain' && _sediaanManualController.text.isEmpty) ||
        (_selectedDurasi == 'Lain-lain' && _durasiManualController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mohon isi semua field')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User tidak terautentikasi');
      }

      if (_waktuMinumList.isEmpty) {
        throw Exception('Waktu minum harus dipilih');
      }

      String waktuMinumString = _waktuMinumList.map((time) => 
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
      ).join(', ');

      // Buat referensi dokumen baru
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('jadwal_obat')
          .doc();

      // Simpan data ke Firestore
      await docRef.set({
        'nama_obat': _namaObatController.text.trim(),
        'sediaan': _selectedSediaan == 'Lain-Lain' ? _sediaanManualController.text.trim() : _selectedSediaan,
        'frekuensi': _selectedFrekuensi,
        'waktu_minum': waktuMinumString,
        'waktu_makan': _selectedWaktuMakan,
        'durasi': _selectedDurasi == 'Lain-lain' ? _durasiManualController.text.trim() : _selectedDurasi,
        'tanggal_dibuat': FieldValue.serverTimestamp(),
        'user_id': user.uid,
      });

      // Jadwalkan notifikasi
      await _scheduleNotifications(
        docRef.id,
        _namaObatController.text.trim(),
        _waktuMinumList,
      );

      // Reset form dan state
      _namaObatController.clear();
      _sediaanManualController.clear();
      _durasiManualController.clear();
      setState(() {
        _waktuMinum = TimeOfDay.now();
        _waktuMinumList = [_waktuMinum];
        _selectedSediaan = 'Sediaan Obat/Jenis';
        _selectedFrekuensi = null;
        _selectedWaktuMakan = null;
        _selectedDurasi = null;
        _showSediaanManual = false;
        _showDurasiManual = false;
      });

      _animationController.reverse().then((_) {
        setState(() {
          _showForm = false;
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Jadwal obat berhasil ditambahkan')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Jadwal Obat', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Container(
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
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('users')
                      .doc(_auth.currentUser?.uid)
                      .collection('jadwal_obat')
                      .orderBy('tanggal_dibuat', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Terjadi kesalahan'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final jadwalList = snapshot.data?.docs ?? [];

                    return ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: jadwalList.length,
                      itemBuilder: (context, index) {
                        final doc = jadwalList[index];
                        final data = doc.data() as Map<String, dynamic>;
                        
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
                          child: Card(
                            margin: EdgeInsets.only(bottom: 16),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.shade200.withOpacity(0.18),
                                    blurRadius: 16,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.13),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Icon(
                                          Icons.medication,
                                          color: Colors.blue,
                                          size: 28,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data['nama_obat'] ?? '',
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue.shade800,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Sediaan: ${data['sediaan'] ?? ''}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () async {
                                          final bool? konfirmasi = await showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Konfirmasi Hapus',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: Text(
                                                  'Apakah Anda yakin ingin menghapus jadwal obat ini?',
                                                  style: GoogleFonts.poppins(),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                    child: Text('Batal'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(true),
                                                    child: Text('Hapus'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (konfirmasi == true) {
                                            await doc.reference.delete();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Jadwal obat dihapus')),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Divider(),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.repeat, size: 20, color: Colors.blue),
                                      SizedBox(width: 8),
                                      Text(
                                        'Frekuensi: ${data['frekuensi'] ?? ''}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, size: 20, color: Colors.blue),
                                      SizedBox(width: 8),
                                      Text(
                                        'Waktu: ${data['waktu_minum'] ?? ''}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.restaurant, size: 20, color: Colors.blue),
                                      SizedBox(width: 8),
                                      Text(
                                        'Waktu Makan: ${data['waktu_makan'] ?? ''}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              if (_showForm)
                Expanded(
                  child: _buildForm(),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showForm = !_showForm;
                      if (_showForm) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _showForm ? 'Batal Tambah Jadwal' : 'Tambah Jadwal Obat',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withOpacity(0.18),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tambah Jadwal Obat',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _namaObatController,
                  decoration: InputDecoration(
                    labelText: 'Nama Obat',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.medication),
                  ),
                ),
                SizedBox(height: 16),
                // Dropdown Sediaan Obat
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSediaan,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      items: _sediaanList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedSediaan = newValue;
                            _showSediaanManual = newValue == 'Lain-Lain';
                            if (!_showSediaanManual) {
                              _sediaanManualController.clear();
                            }
                          });
                        }
                      },
                    ),
                  ),
                ),
                // Field Manual untuk Sediaan Lain-lain
                if (_showSediaanManual) ...[
                  SizedBox(height: 16),
                  TextField(
                    controller: _sediaanManualController,
                    decoration: InputDecoration(
                      labelText: 'Sebutkan Sediaan Obat',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.edit),
                    ),
                  ),
                ],
                SizedBox(height: 16),
                // Dropdown Frekuensi
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.repeat, color: Colors.grey),
                      SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedFrekuensi,
                            hint: Text(
                              'Frekuensi Pemakaian',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            items: _frekuensiList.skip(1).map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedFrekuensi = newValue;
                                  // Hitung ulang waktu minum jika frekuensi berubah
                                  if (_waktuMinumList.isNotEmpty) {
                                    _hitungWaktuMinum(_waktuMinumList[0]);
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Dropdown Waktu Makan
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.restaurant, color: Colors.grey),
                      SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedWaktuMakan,
                            hint: Text(
                              'Waktu Makan',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            items: _waktuMakanList.skip(1).map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedWaktuMakan = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Dropdown Durasi
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey),
                      SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedDurasi,
                            hint: Text(
                              'Durasi Pemakaian',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            items: _durasiList.skip(1).map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedDurasi = newValue;
                                  _showDurasiManual = newValue == 'Lain-lain';
                                  if (!_showDurasiManual) {
                                    _durasiManualController.clear();
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Field Manual untuk Durasi Lain-lain
                if (_showDurasiManual) ...[
                  SizedBox(height: 16),
                  TextField(
                    controller: _durasiManualController,
                    decoration: InputDecoration(
                      labelText: 'Sebutkan Durasi Minum',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.edit),
                    ),
                  ),
                ],
                SizedBox(height: 16),
                // Waktu Minum
                InkWell(
                  onTap: _pilihWaktu,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.grey),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Waktu Pemakaian',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _waktuMinumList.isEmpty 
                                    ? 'Pilih Waktu'
                                    : _waktuMinumList.map((time) => 
                                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                                      ).join(', '),
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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