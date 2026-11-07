import 'package:flutter/material.dart';

import 'register_screen.dart';
import 'main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  static const Color navy = Color(0xFF10213D);
  static const Color coral = Color(0xFFE85D4A);
  static const Color background = Color(0xFFF4F7FB);
  static const Color secondary = Color(0xFF68778C);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // LOGO DAN IDENTITAS
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          color: navy,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        'RUANG KABAR',
                        style: TextStyle(
                          color: navy,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontFamily: 'Georgia',
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'Your daily reading space',
                        style: TextStyle(color: secondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 38),

                // FORM LOGIN
                Container(
                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFDCE5EF)),
                    boxShadow: [
                      BoxShadow(
                        color: navy.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Form(
                    key: _formKey,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selamat Datang!',
                          style: TextStyle(
                            color: navy,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 7),

                        const Text(
                          'Masuk untuk menjelajahi berbagai '
                          'informasi terbaru bersama kami.',
                          style: TextStyle(
                            color: secondary,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 27),

                        // EMAIL
                        const Text(
                          'Email',
                          style: TextStyle(
                            color: navy,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 9),

                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,

                          decoration: InputDecoration(
                            hintText: 'Masukkan email kamu',
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: secondary,
                            ),
                            filled: true,
                            fillColor: background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFDCE5EF),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: coral,
                                width: 1.5,
                              ),
                            ),
                          ),

                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email harus diisi';
                            }

                            if (!value.contains('@')) {
                              return 'Format email tidak valid';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // PASSWORD
                        const Text(
                          'Kata Sandi',
                          style: TextStyle(
                            color: navy,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 9),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,

                          decoration: InputDecoration(
                            hintText: 'Masukkan kata sandi',

                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: secondary,
                            ),

                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: secondary,
                              ),
                            ),

                            filled: true,
                            fillColor: background,

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFDCE5EF),
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: coral,
                                width: 1.5,
                              ),
                            ),
                          ),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kata sandi harus diisi';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 28),

                        // TOMBOL MASUK
                        SizedBox(
                          width: double.infinity,
                          height: 52,

                          child: ElevatedButton(
                            onPressed: _login,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: coral,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Masuk Sekarang',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 9),
                                Icon(Icons.arrow_forward_rounded, size: 18),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // REGISTER
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              const Text(
                                'Belum punya akun? ',
                                style: TextStyle(
                                  color: secondary,
                                  fontSize: 12,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },

                                child: const Text(
                                  'Daftar Sekarang',
                                  style: TextStyle(
                                    color: coral,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // FOOTER
                const Center(
                  child: Text(
                    'RUANG KABAR • READ MORE, KNOW MORE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: secondary,
                      fontSize: 9,
                      letterSpacing: 1,
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
