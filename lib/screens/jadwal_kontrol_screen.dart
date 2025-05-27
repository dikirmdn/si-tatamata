import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JadwalKontrolScreen extends StatefulWidget {
  @override
  _JadwalKontrolScreenState createState() => _JadwalKontrolScreenState();
}

class _JadwalKontrolScreenState extends State<JadwalKontrolScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _showForm = false;
  
  // Controller untuk form
  final _judulController = TextEditingController();
  String _selectedDokter = '';
  bool _tambahKeKalender = false;
  String _selectedLokasi = '';
  
  // State untuk tanggal dan waktu
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  
  // Daftar dokter (contoh)
  final List<String> _dokterList = [
    'dr. Ahmad Sp.M',
    'dr. Sarah Sp.M',
    'dr. Budi Sp.M',
  ];

  // Daftar lokasi
  final List<String> _lokasiList = [
    'Cabang A',
    'Cabang B',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
                      .collection('jadwal_kontrol')
                      .where('userId', isEqualTo: _auth.currentUser?.uid)
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
                                        child: Text(
                                          jadwal['judul'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade800,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () async {
                                          await _firestore
                                              .collection('jadwal_kontrol')
                                              .doc(jadwalId)
                                              .delete();
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(Icons.person, color: Colors.blue, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Dokter: ${jadwal['dokter']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
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
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (jadwal['tambahKeKalender']) ...[
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          'Tanggal: ${(jadwal['tanggal'] as Timestamp).toDate().day}/${(jadwal['tanggal'] as Timestamp).toDate().month}/${(jadwal['tanggal'] as Timestamp).toDate().year}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
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
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
              if (_showForm) _buildForm(),
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            CheckboxListTile(
              title: Text('Tambah ke kalender', style: GoogleFonts.poppins()),
              value: _tambahKeKalender,
              activeColor: Colors.blue,
              checkColor: Colors.white,
              onChanged: (bool? value) {
                setState(() {
                  _tambahKeKalender = value!;
                });
              },
            ),
            if (_tambahKeKalender) ...[
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
            ],
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
                          await _firestore.collection('jadwal_kontrol').add({
                            'userId': _auth.currentUser?.uid,
                            'judul': _judulController.text,
                            'dokter': _selectedDokter,
                            'tambahKeKalender': _tambahKeKalender,
                            'lokasi': _selectedLokasi,
                            'tanggal': _tambahKeKalender ? Timestamp.fromDate(_selectedDate) : null,
                            'waktu': _tambahKeKalender ? _selectedTime.format(context) : null,
                            'createdAt': FieldValue.serverTimestamp(),
                          });
                          
                          setState(() {
                            _showForm = false;
                            _resetForm();
                          });
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Jadwal berhasil ditambahkan')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Gagal menambahkan jadwal: $e')),
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
    );
  }

  void _resetForm() {
    _judulController.clear();
    _selectedDokter = '';
    _tambahKeKalender = false;
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