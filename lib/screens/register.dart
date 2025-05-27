import 'package:flutter/material.dart';
import 'package:simata/screens/login.dart';
import 'dart:ui';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _usiaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedGender;

  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: Duration(milliseconds: 700),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 40 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Card(
                  elevation: 12,
                  shadowColor: Colors.blue.shade100.withOpacity(0.4),
                  color: Colors.white.withOpacity(0.95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Judul besar
                          Text(
                            'Daftar',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Buat akun baru untuk mulai menggunakan aplikasi',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueGrey.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 28),
                          // Gambar User
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: Colors.blue.shade100,
                            backgroundImage: AssetImage('assets/images/logo.png'),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.shade100,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.person, size: 20, color: Colors.blue.shade700),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          // Nama
                          TextFormField(
                            controller: _namaController,
                            decoration: InputDecoration(
                              labelText: 'Nama',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              prefixIcon: Icon(Icons.person_outline),
                              filled: true,
                              fillColor: Colors.blue.shade50.withOpacity(0.2),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Nama wajib diisi' : null,
                          ),
                          SizedBox(height: 16),
                          // Jenis Kelamin
                          DropdownButtonFormField<String>(
                            value: _selectedGender,
                            decoration: InputDecoration(
                              labelText: 'Jenis Kelamin',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              prefixIcon: Icon(Icons.wc),
                              filled: true,
                              fillColor: Colors.blue.shade50.withOpacity(0.2),
                            ),
                            items: _genderOptions.map((gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                            validator: (value) =>
                                value == null ? 'Pilih jenis kelamin' : null,
                          ),
                          SizedBox(height: 16),
                          // Usia
                          TextFormField(
                            controller: _usiaController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Usia',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              prefixIcon: Icon(Icons.cake_outlined),
                              filled: true,
                              fillColor: Colors.blue.shade50.withOpacity(0.2),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Usia wajib diisi' : null,
                          ),
                          SizedBox(height: 16),
                          // Email
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              prefixIcon: Icon(Icons.email_outlined),
                              filled: true,
                              fillColor: Colors.blue.shade50.withOpacity(0.2),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Email wajib diisi' : null,
                          ),
                          SizedBox(height: 16),
                          // Password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              prefixIcon: Icon(Icons.lock_outline),
                              filled: true,
                              fillColor: Colors.blue.shade50.withOpacity(0.2),
                            ),
                            validator: (value) =>
                                value!.length < 6 ? 'Minimal 6 karakter' : null,
                          ),
                          SizedBox(height: 28),
                          // Tombol Daftar dengan efek gradient
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade700,
                                    Colors.blue.shade400,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.shade200.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Pendaftaran berhasil!')),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text('Daftar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          // Divider dengan tulisan "atau"
                          Row(
                            children: [
                              Expanded(child: Divider(thickness: 1, color: Colors.blue.shade100)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('atau', style: TextStyle(color: Colors.blueGrey.shade400)),
                              ),
                              Expanded(child: Divider(thickness: 1, color: Colors.blue.shade100)),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Sudah punya akun? ", style: TextStyle(color: Colors.blueGrey.shade700)),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => LoginScreen()),
                                  );
                                },
                                child: Text('Klik di sini', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
