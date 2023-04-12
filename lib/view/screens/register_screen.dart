import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project_bank_sampah/common/overlay_manager.dart';
import 'package:mini_project_bank_sampah/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../common/utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isObscure = true;

  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
    _nameController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //scaffold screen with for register screen
    //create form with email
    //create password textfield with hide/show password
    //create register button
    //create login button

    return Scaffold(
      backgroundColor: hexToColor('#F0F6DC'),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Image.asset(
                        "assets/logo_sahaja.png",
                        width: 72,
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Text(
                        "Bank Sampah\nSahaja".toUpperCase(),
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    hintText: "Masukan Nama Lengkap",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: "Masukkan Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Row(
                  children: const [
                    Text("format: youremail@gmail.com"),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  obscureText: isObscure,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                    labelText: 'Password',
                    hintText: "Masukkan Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      flex: 4,
                      child: TextButton(
                        onPressed: () async {
                          try {
                            OverlayManager().showOverlay(
                              context,
                              Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                            await context.read<AuthViewmodel>().register(
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                  name: _nameController.text,
                                );
                            OverlayManager().hideOverlay();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Register Berhasil, silahkan konfirmasi email dan beralih ke halaman login",
                                ),
                              ),
                            );
                          } on Exception catch (e) {
                            OverlayManager().hideOverlay();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Register Gagal, Silahkan lengkapi data dengan benar",
                                ),
                              ),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: hexToColor("#7A9D30"),
                        ),
                        child: Text(
                          "Daftar",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.livvic(
                              color: hexToColor("#F0F6DC"), fontSize: 18),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
                // text button with text daftar, border color #7A9D30, and navigate to register page
                Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      flex: 4,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          side: BorderSide(
                            color: hexToColor("#7A9D30"),
                          ),
                        ),
                        child: Text(
                          "sudah punya akun? Login",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.livvic(
                              color: hexToColor("#7A9D30"), fontSize: 18),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
