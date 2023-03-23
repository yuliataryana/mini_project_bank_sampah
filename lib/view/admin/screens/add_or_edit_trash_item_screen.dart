import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_project_bank_sampah/common/overlay_manager.dart';
import 'package:mini_project_bank_sampah/model/waste_category.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/main_viewmodel.dart';

class AddOrEditTrashItemScreen extends StatefulWidget {
  const AddOrEditTrashItemScreen({
    super.key,
    this.wasteCategory,
  });
  final WasteCategory? wasteCategory;

  @override
  State<AddOrEditTrashItemScreen> createState() =>
      _AddOrEditTrashItemScreenState();
}

class _AddOrEditTrashItemScreenState extends State<AddOrEditTrashItemScreen> {
  bool get isEdit => widget.wasteCategory != null;
  late final TextEditingController _nameController, _priceController;

  String? imagePath;

  @override
  void initState() {
    _nameController =
        TextEditingController(text: widget.wasteCategory?.wasteName);
    _priceController = TextEditingController(
      text: widget.wasteCategory?.wastePrice.toString(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Sampah"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                isEdit
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () async {
                            try {
                              final result = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );
                              setState(() {
                                imagePath = result?.path;
                              });
                            } catch (e) {}
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: imagePath != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.file(
                                      File(imagePath!),
                                      width: 250,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    width: 250,
                                    height: 250,
                                    padding: const EdgeInsets.all(8),
                                    child: const Center(
                                      child: Icon(Icons.add_a_photo_outlined),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                // name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Sampah",
                  ),
                ),
                // price
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Harga",
                    suffix: Text(
                      "/Kg",
                    ),
                    prefix: Text(
                      "Rp.",
                    ),
                  ),
                ),
                // image

                // description

                // button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      // execute add or edit method on MainViewmodel
                      // show overlay loading when processing data
                      // if success, pop screen
                      // if failed, show error message

                      // show overlay loading
                      OverlayManager().showOverlay(
                        context,
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      final result = await context
                          .read<MainViewmodel>()
                          .addOrUpdateWasteCategory(
                            isEdit
                                ? widget.wasteCategory!.copyWith(
                                    wasteName: _nameController.text,
                                    wastePrice:
                                        int.parse(_priceController.text),
                                  )
                                : WasteCategory(
                                    wasteName: _nameController.text,
                                    wastePrice:
                                        int.parse(_priceController.text),
                                    imageUrl: "",
                                  ),
                            imagePath: imagePath,
                          );
                      OverlayManager().hideOverlay();
                      if (result) {
                        context.read<MainViewmodel>().fetchWasteCategories();
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Gagal menambahkan sampah"),
                          ),
                        );
                      }
                    },
                    child: Text(isEdit ? "Simpan" : "Tambah"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
