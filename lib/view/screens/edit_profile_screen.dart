import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_project_bank_sampah/model/user_profile.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../common/overlay_manager.dart';
import '../../common/utils.dart';
import '../../viewmodel/auth_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.userProfile});
  final UserProfile userProfile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // form controller
  late final TextEditingController _nameController,
      _phoneController,
      _addressController;

  @override
  void initState() {
    // initialize form controller
    _nameController = TextEditingController(
      text: widget.userProfile.username,
    );
    _phoneController = TextEditingController(
      text: widget.userProfile.phone,
    );
    _addressController = TextEditingController(
      text: widget.userProfile.address,
    );
    super.initState();
  }

  @override
  void dispose() {
    // dispose form controller
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // create scaffold page with appbar, body with avatar image and listtile of profile information
    return Scaffold(
      backgroundColor: hexToColor('#F0F6DC'),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // SizedBox(
              //   width: MediaQuery.of(context).size.width,
              //   height: MediaQuery.of(context).size.height * 0.25,
              //   child: Stack(
              //     children: [
              //       Positioned.fill(
              //         child: Column(children: [
              //           Expanded(
              //             child: Container(
              //               color: Theme.of(context).primaryColor,
              //             ),
              //           ),
              //           Expanded(
              //             child: Container(
              //               color: hexToColor('#F0F6DC'),
              //             ),
              //           ),
              //         ]),
              //       ),
              //       Align(
              //         alignment: Alignment.center,
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: CircleAvatar(
              //             radius: 75,
              //             backgroundImage: (accountForm?.photo == null ||
              //                     (accountForm?.photo.isEmpty ?? true))
              //                 ? const AssetImage('assets/profil.png')
              //                 : (FileImage(
              //                     File(accountForm!.photo),
              //                   ) as ImageProvider),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              //create form for properties on accountForm class
              Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: TextFormField(
                    //       // initialValue: accountForm?.email,
                    //       decoration: const InputDecoration(
                    //         labelText: 'Email',
                    //         border: OutlineInputBorder(),
                    //       ),
                    //       onChanged: (value) => context
                    //       // .read<AuthViewmodel>()
                    //       // .setAccountForm(
                    //       //     accountForm?.copyWith(email: value)),
                    //       ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _addressController,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
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
                  Expanded(
                    flex: 4,
                    child: TextButton(
                      onPressed: () async {
                        try {
                          OverlayManager().showOverlay(
                            context,
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          await context.read<AuthViewmodel>().saveProfile(
                                name: _nameController.text,
                                phone: _phoneController.text,
                                address: _addressController.text,
                              );

                          OverlayManager().hideOverlay();
                          Navigator.pop(context);
                        } on Exception catch (e) {
                          OverlayManager().hideOverlay();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                e.toString().replaceAll("Exception:", ""),
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
                        "Simpan",
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
