import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class JadwalKontrolScreen extends StatefulWidget {
  @override
  _JadwalKontrolScreenState createState() => _JadwalKontrolScreenState();
}

class _JadwalKontrolScreenState extends State<JadwalKontrolScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _showForm = false;
  
  // Inisialisasi FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // Controller untuk form
  final _judulController = TextEditingController();
  String _selectedDokter = '';
  String _selectedLokasi = '';
  
  // State untuk tanggal dan waktu
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  
  // Daftar dokter (contoh)
  final List<String> _dokterList = [
    'dr. Diki Sp.M',
    'dr. Sarah Sp.M',
    'dr. Budi Sp.M',
  ];

  // Daftar lokasi
  final List<String> _lokasiList = [
    'Cabang A',
    'Cabang B',
  ];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  // Inisialisasi notifikasi
  Future<void> _initializeNotifications() async {
    // Inisialisasi timezone
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Fungsi untuk menampilkan notifikasi
  Future<void> _showNotification(String title, String body, DateTime scheduledTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'jadwal_kontrol_channel',
      'Jadwal Kontrol',
      channelDescription: 'Notifikasi untuk jadwal kontrol',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Konversi DateTime ke TZDateTime
    final scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Jadwal Kontrol', 
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22)
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
                      .collection('jadwal_kontrol')
                      .orderBy('tanggal', descending: false)
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
                        final jadwal = jadwalList[index].data() as Map<String, dynamic>;
                        final jadwalId = jadwalList[index].id;
                        
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
                                          Icons.event_note,
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
                                              jadwal['judul'],
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue.shade800,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Dokter: ${jadwal['dokter']}',
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
                                          // Menampilkan dialog konfirmasi
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
                                                  'Apakah Anda yakin ingin menghapus janji temu ini?',
                                                  style: GoogleFonts.poppins(),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                    child: Text(
                                                      'Batal',
                                                      style: GoogleFonts.poppins(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(true),
                                                    child: Text(
                                                      'Hapus',
                                                      style: GoogleFonts.poppins(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (konfirmasi == true) {
                                            await _firestore
                                                .collection('users')
                                                .doc(_auth.currentUser?.uid)
                                                .collection('jadwal_kontrol')
                                                .doc(jadwalId)
                                                .delete();
                                            
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Janji temu berhasil dihapus'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Tanggal: ${(jadwal['tanggal'] as Timestamp).toDate().day}/${(jadwal['tanggal'] as Timestamp).toDate().month}/${(jadwal['tanggal'] as Timestamp).toDate().year}',
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
                                      Icon(Icons.access_time, color: Colors.blue, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Waktu: ${jadwal['waktu']}',
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
                                      Icon(Icons.location_on, color: Colors.blue, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Lokasi: ${jadwal['lokasi']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      final Event event = Event(
                                        title: jadwal['judul'],
                                        description: 'Janji temu dengan ${jadwal['dokter']} di ${jadwal['lokasi']}',
                                        location: jadwal['lokasi'],
                                        startDate: (jadwal['tanggal'] as Timestamp).toDate(),
                                        endDate: (jadwal['tanggal'] as Timestamp).toDate().add(Duration(hours: 1)),
                                      );
                                      Add2Calendar.addEvent2Cal(event);
                                    },
                                    icon: Icon(Icons.calendar_today, color: Colors.white),
                                    label: Text(
                                      'Tambah ke Kalender',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
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
                    _showForm ? 'Batal Tambah Janji' : 'Tambah Janji Temu',
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
                  controller: _judulController,
                  decoration: InputDecoration(
                    labelText: 'Judul Janji',
                    labelStyle: GoogleFonts.poppins(color: Colors.blue.shade800),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.event_note, color: Colors.blue),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul janji harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedDokter.isEmpty ? null : _selectedDokter,
                  decoration: InputDecoration(
                    labelText: 'Pilih Dokter',
                    labelStyle: GoogleFonts.poppins(color: Colors.blue.shade800),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.blue),
                  ),
                  items: _dokterList.map((String dokter) {
                    return DropdownMenuItem<String>(
                      value: dokter,
                      child: Text(dokter, style: GoogleFonts.poppins()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDokter = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silakan pilih dokter';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (picked != null && picked != _selectedDate) {
                            setState(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                        icon: Icon(Icons.calendar_today),
                        label: Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
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
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                          );
                          if (picked != null && picked != _selectedTime) {
                            setState(() {
                              _selectedTime = picked;
                            });
                          }
                        },
                        icon: Icon(Icons.access_time),
                        label: Text(
                          _selectedTime.format(context),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
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
                  ],
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedLokasi.isEmpty ? null : _selectedLokasi,
                  decoration: InputDecoration(
                    labelText: 'Lokasi',
                    labelStyle: GoogleFonts.poppins(color: Colors.blue.shade800),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.location_on, color: Colors.blue),
                  ),
                  items: _lokasiList.map((String lokasi) {
                    return DropdownMenuItem<String>(
                      value: lokasi,
                      child: Text(lokasi, style: GoogleFonts.poppins()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLokasi = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silakan pilih lokasi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              // Gabungkan tanggal dan waktu
                              final DateTime scheduledDateTime = DateTime(
                                _selectedDate.year,
                                _selectedDate.month,
                                _selectedDate.day,
                                _selectedTime.hour,
                                _selectedTime.minute,
                              );

                              // Waktu notifikasi (1 jam sebelum)
                              final DateTime notificationTime = scheduledDateTime.subtract(Duration(hours: 1));

                              await _firestore
                                  .collection('users')
                                  .doc(_auth.currentUser?.uid)
                                  .collection('jadwal_kontrol')
                                  .add({
                                'judul': _judulController.text,
                                'dokter': _selectedDokter,
                                'lokasi': _selectedLokasi,
                                'tanggal': Timestamp.fromDate(_selectedDate),
                                'waktu': _selectedTime.format(context),
                                'createdAt': FieldValue.serverTimestamp(),
                              });

                              // Set notifikasi
                              await _showNotification(
                                'Pengingat Jadwal Kontrol',
                                'Anda memiliki jadwal kontrol dengan ${_selectedDokter} di ${_selectedLokasi} dalam 1 jam',
                                notificationTime,
                              );
                              
                              // Reset form dan sembunyikan
                              _resetForm();
                              if (mounted) {
                                setState(() {
                                  _showForm = false;
                                });
                              }
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Jadwal berhasil ditambahkan dan pengingat telah diatur'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Gagal menambahkan jadwal: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        icon: Icon(Icons.check),
                        label: Text('Kirim Janji', 
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
                        label: Text('Hapus Janji', style: GoogleFonts.poppins()),
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
    _judulController.clear();
    _selectedDokter = '';
    _selectedLokasi = '';
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _judulController.dispose();
    super.dispose();
  }
} 