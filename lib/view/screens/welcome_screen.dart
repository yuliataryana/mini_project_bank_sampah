import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/utils.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor('#F0F6DC'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome To",
              textAlign: TextAlign.center,
              style: GoogleFonts.livvic(
                  fontSize: 44, color: hexToColor("#7A9D30")),
              textScaleFactor: 1,
            ),
            Text(
              "Bank Sampah SAHAJA",
              textAlign: TextAlign.center,
              style: GoogleFonts.livvic(
                  fontSize: 44, color: hexToColor("#7A9D30")),
              textScaleFactor: 1,
            ),
            const SizedBox(height: 10),
            Image.asset(
              "assets/logo_sahaja.png",
              width: 200,
            ),
            const SizedBox(height: 10),
            //text button with text masuk,color #7A9D30, and navigate to login page
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
                      backgroundColor: hexToColor("#7A9D30"),
                    ),
                    child: Text(
                      "Masuk",
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
                      Navigator.pushNamed(context, '/register');
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
                      "Daftar",
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
    );
  }
}
