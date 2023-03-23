import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_project_bank_sampah/common/overlay_manager.dart';
import 'package:mini_project_bank_sampah/common/utils.dart';
import 'package:mini_project_bank_sampah/viewmodel/main_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../viewmodel/auth_viewmodel.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final loggedAccount = context.watch<AuthViewmodel>().loggedAccount;

    // create scaffold page with appbar, body with avatar image and listtile of profile information
    final profile = context.watch<AuthViewmodel>().userProfile;
    final authDetail = Supabase.instance.client.auth.currentUser;
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
                      child: Column(
                        children: [
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
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Builder(builder: (context) {
                                  if (profile?.photoProfile != null) {
                                    return CircleAvatar(
                                      radius: 75,
                                      backgroundImage: NetworkImage(
                                        profile!.photoProfile!,
                                      ),
                                    );
                                  }
                                  return CircleAvatar(
                                    radius: 75,
                                    // backgroundImage: AssetImage(
                                    //   'assets/profil.png',
                                    // ),
                                  );
                                }),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  iconSize: 32,
                                  // color: Colors.grey,
                                  icon:
                                      const Icon(Icons.change_circle_outlined),
                                  onPressed: () async {
                                    // using image pciker to change profile picture
                                    final pickedFile = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      // show overlay loading
                                      try {
                                        OverlayManager().showOverlay(
                                          context,
                                          const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                        await context
                                            .read<AuthViewmodel>()
                                            .updateProfilePicture(
                                              pickedFile.path,
                                            );
                                        // hide overlay loading
                                        OverlayManager().hideOverlay();
                                      } catch (e) {
                                        print(e);
                                        OverlayManager().hideOverlay();
                                      }
                                    }
                                  },
                                ),
                              )
                            ],
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
                      Navigator.pushNamed(
                        context,
                        '/profile/edit',
                        arguments: profile!,
                      );
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
                trailing: Text(profile?.username ?? "-"),
              ),
              ListTile(
                title: const Text('Email'),
                trailing: Text(authDetail?.email ?? "-"),
              ),
              ListTile(
                title: const Text('No. HP'),
                trailing: Text(profile?.phone ?? "-"),
              ),
              ListTile(
                title: const Text('Alamat'),
                trailing: Text(profile?.address ?? "-"),
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
                          context.read<MainViewmodel>().clearCart();
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
