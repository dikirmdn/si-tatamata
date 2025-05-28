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
  final _formKey = GlobalKey<FormState>();
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
    _showForm = false;
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
      final notificationId = (docId.hashCode.abs() % 2147483647) + i;
      
      // Set alarm untuk waktu minum obat
      await _notificationService.scheduleAlarm(
        id: notificationId,
        title: 'Waktunya Minum Obat',
        body: 'Waktunya minum $namaObat pada pukul ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
        scheduledTime: scheduledTime,
        isAlarm: true,
      );

      // Set pengingat 5 menit sebelum
      final fiveMinutesBefore = scheduledTime.subtract(Duration(minutes: 5));
      if (fiveMinutesBefore.isAfter(now)) {
        await _notificationService.scheduleAlarm(
          id: notificationId + 1000, // ID berbeda untuk pengingat
          title: 'Pengingat Minum Obat',
          body: 'Anda akan minum $namaObat dalam 5 menit',
          scheduledTime: fiveMinutesBefore,
          isAlarm: false, // Pengingat tidak menggunakan alarm
        );
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Jadwal Obat', 
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
                                              SnackBar(
                                                content: Text('Jadwal obat berhasil dihapus'),
                                                backgroundColor: Colors.green,
                                              ),
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
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
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
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _namaObatController,
                  decoration: InputDecoration(
                    labelText: 'Nama Obat',
                    labelStyle: GoogleFonts.poppins(color: Colors.blue.shade800),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.medication, color: Colors.blue),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama obat harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedSediaan == 'Sediaan Obat/Jenis' ? null : _selectedSediaan,
                  decoration: InputDecoration(
                    labelText: 'Sediaan Obat',
                    labelStyle: GoogleFonts.poppins(color: Colors.blue.shade800),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.medication_liquid, color: Colors.blue),
                  ),
                  items: _sediaanList.skip(1).map((String sediaan) {
                    return DropdownMenuItem<String>(
                      value: sediaan,
                      child: Text(sediaan, style: GoogleFonts.poppins()),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silakan pilih sediaan obat';
                    }
                    return null;
                  },
                ),
                if (_showSediaanManual) ...[
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _sediaanManualController,
                    decoration: InputDecoration(
                      labelText: 'Sebutkan Sediaan Obat',
                      labelStyle: GoogleFonts.poppins(color: Colors.blue.shade800),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.edit, color: Colors.blue),
                    ),
                    validator: (value) {
                      if (_showSediaanManual && (value == null || value.isEmpty)) {
                        return 'Sediaan obat harus diisi';
                      }
                      return null;
                    },
                  ),
                ],
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedFrekuensi,
                  decoration: InputDecoration(
                    labelText: 'Frekuensi Pemakaian',
                    labelStyle: GoogleFonts.poppins(color: Colors.blue.shade800),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.repeat, color: Colors.blue),
                  ),
                  items: _frekuensiList.skip(1).map((String frekuensi) {
                    return DropdownMenuItem<String>(
                      value: frekuensi,
                      child: Text(frekuensi, style: GoogleFonts.poppins()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedFrekuensi = newValue;
                        if (_waktuMinumList.isNotEmpty) {
                          _hitungWaktuMinum(_waktuMinumList[0]);
                        }
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silakan pilih frekuensi pemakaian';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedWaktuMakan,
                  decoration: InputDecoration(
                    labelText: 'Waktu Makan',
                    labelStyle: GoogleFonts.poppins(color: Colors.blue.shade800),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.restaurant, color: Colors.blue),
                  ),
                  items: _waktuMakanList.skip(1).map((String waktu) {
                    return DropdownMenuItem<String>(
                      value: waktu,
                      child: Text(waktu, style: GoogleFonts.poppins()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedWaktuMakan = newValue;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silakan pilih waktu makan';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedDurasi,
                  decoration: InputDecoration(
                    labelText: 'Durasi Pemakaian',
                    labelStyle: GoogleFonts.poppins(color: Colors.blue.shade800),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
                  ),
                  items: _durasiList.skip(1).map((String durasi) {
                    return DropdownMenuItem<String>(
                      value: durasi,
                      child: Text(durasi, style: GoogleFonts.poppins()),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silakan pilih durasi pemakaian';
                    }
                    return null;
                  },
                ),
                if (_showDurasiManual) ...[
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _durasiManualController,
                    decoration: InputDecoration(
                      labelText: 'Sebutkan Durasi Minum',
                      labelStyle: GoogleFonts.poppins(color: Colors.blue.shade800),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.edit, color: Colors.blue),
                    ),
                    validator: (value) {
                      if (_showDurasiManual && (value == null || value.isEmpty)) {
                        return 'Durasi minum harus diisi';
                      }
                      return null;
                    },
                  ),
                ],
                SizedBox(height: 16),
                InkWell(
                  onTap: _pilihWaktu,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.blue),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Waktu Pemakaian',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.blue.shade800,
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
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : () async {
                          if (_formKey.currentState!.validate()) {
                            await _tambahJadwalObat();
                          }
                        },
                        icon: Icon(Icons.check),
                        label: Text('Simpan', 
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          )
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade800,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _resetForm,
                        icon: Icon(Icons.delete),
                        label: Text('Reset', style: GoogleFonts.poppins()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetForm() {
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
  }

  Future<void> _tambahJadwalObat() async {
    if (_namaObatController.text.isEmpty || 
        _selectedFrekuensi == null ||
        _selectedWaktuMakan == null ||
        _selectedDurasi == null ||
        (_selectedSediaan == 'Lain-Lain' && _sediaanManualController.text.isEmpty) ||
        (_selectedDurasi == 'Lain-lain' && _durasiManualController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mohon isi semua field'),
          backgroundColor: Colors.red,
        ),
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
        _showForm = false;
      });

      _animationController.reverse();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Jadwal obat berhasil ditambahkan dan pengingat telah diatur'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
} 