import 'package:flutter/material.dart';
import 'package:simata/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register.dart';
import 'dart:ui';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (userCredential.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message;
        
        switch (e.code) {
          case 'user-not-found':
          case 'wrong-password':
            message = 'Email atau password salah';
            break;
          case 'invalid-email':
            message = 'Format email tidak valid';
            break;
          case 'user-disabled':
            message = 'Akun telah dinonaktifkan';
            break;
          case 'too-many-requests':
            message = 'Terlalu banyak percobaan login. Silakan coba lagi nanti';
            break;
          default:
            message = 'Email atau Password salah';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
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
                            'Masuk',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Masuk ke akun Anda untuk melanjutkan',
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
                          // Email
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              prefixIcon: Icon(Icons.email_outlined),
                              filled: true,
                              fillColor: Colors.blue.shade50.withOpacity(0.2),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                value!.isEmpty ? 'Email wajib diisi' : null,
                          ),
                          SizedBox(height: 16),
                          // Password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              prefixIcon: Icon(Icons.lock_outline),
                              filled: true,
                              fillColor: Colors.blue.shade50.withOpacity(0.2),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Password wajib diisi' : null,
                          ),
                          SizedBox(height: 28),
                          // Tombol Masuk dengan efek gradient
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
                                onPressed: _isLoading ? null : _signIn,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Text('Masuk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
                              Text("Belum punya akun? ", style: TextStyle(color: Colors.blueGrey.shade700)),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                                  );
                                },
                                child: Text('Daftar di sini', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
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
