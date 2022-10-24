import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project_bank_sampah/common/utils.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/auth_viewmodel.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedAccount = context.watch<AuthViewmodel>().loggedAccount;

    // create scaffold page with appbar, body with avatar image and listtile of profile information
    return Scaffold(
      backgroundColor: hexToColor('#F0F6DC'),
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Column(children: [
                        Expanded(
                          child: Container(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: hexToColor('#F0F6DC'),
                          ),
                        ),
                      ]),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 75,
                          backgroundImage: AssetImage(
                            'assets/profil.png',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile/edit');
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: hexToColor("#7A9D30"),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        " Edit Profile ",
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
              const SizedBox(
                height: 24,
              ),
              ListTile(
                title: const Text('Nama'),
                trailing: Text(loggedAccount?.name ?? "-"),
              ),
              ListTile(
                title: const Text('Email'),
                trailing: Text(loggedAccount?.email ?? "-"),
              ),
              ListTile(
                title: const Text('No. HP'),
                trailing: Text(loggedAccount?.phone ?? "-"),
              ),
              ListTile(
                title: const Text('Alamat'),
                trailing: Text(loggedAccount?.address ?? "-"),
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
                      onPressed: () {
                        try {
                          context.read<AuthViewmodel>().logout();
                          Navigator.pushNamed(context, '/login');
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: hexToColor("#7A9D30"),
                      ),
                      child: Text(
                        "Keluar",
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
            ],
          ),
        ],
      ),
    );
  }
}
