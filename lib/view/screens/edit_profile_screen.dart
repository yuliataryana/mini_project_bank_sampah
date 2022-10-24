import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../common/utils.dart';
import '../../viewmodel/auth_viewmodel.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  // accountForm;

  @override
  Widget build(BuildContext context) {
    final accountForm = context.watch<AuthViewmodel>().accountForm;
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
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 75,
                          backgroundImage: (accountForm?.photo == null ||
                                  (accountForm?.photo.isEmpty ?? true))
                              ? const AssetImage('assets/profil.png')
                              : (FileImage(
                                  File(accountForm!.photo),
                                ) as ImageProvider),
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
                    onPressed: () async {
                      try {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        context
                            .read<AuthViewmodel>()
                            .setAccountForm(accountForm?.copyWith(
                              photo: pickedFile!.path,
                            ));
                      } catch (e) {}
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
                        " Ubah Foto",
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
              //create form for properties on accountForm class
              Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: accountForm?.name ?? "",
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          context.read<AuthViewmodel>().setAccountForm(
                              accountForm?.copyWith(name: value));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: accountForm?.email,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => context
                            .read<AuthViewmodel>()
                            .setAccountForm(
                                accountForm?.copyWith(email: value)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: accountForm?.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => context
                            .read<AuthViewmodel>()
                            .setAccountForm(
                                accountForm?.copyWith(phone: value)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: accountForm?.address,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) =>
                            context.read<AuthViewmodel>().setAccountForm(
                                  accountForm?.copyWith(address: value),
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
                          await context.read<AuthViewmodel>().saveProfile();
                          Future.delayed(Duration.zero, () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile saved'),
                              ),
                            );
                            Navigator.of(context).pop();
                          });
                        } on Exception catch (e) {
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
