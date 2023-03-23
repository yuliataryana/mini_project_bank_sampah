import 'dart:io';

import 'package:mini_project_bank_sampah/service/base_service.dart';

import '../model/waste_category.dart';

class WasteService extends BaseService {
  // implement singleton
  WasteService._internal();
  static final _singleton = WasteService._internal();
  factory WasteService() => _singleton;

  @override
  String get path => "waste_category";

  Future<List<WasteCategory>> getWasteCategories() async {
    try {
      final response = await supabaseClient.from(path).select();

      final data = response as List;
      return data.map((e) => WasteCategory.fromJson(e)).toList();
    } catch (e) {
      print(e);
    }
    return [];
  }

  //  update item waste categories
  Future<bool> updateWasteCategories(WasteCategory wasteCategory) async {
    try {
      final response = await supabaseClient
          .from(path)
          .update(wasteCategory.toJson())
          .eq('id_waste', wasteCategory.idWaste)
          .select();

      final data = response as List;
      return data.isNotEmpty;
    } catch (e) {
      print(e);
    }
    return false;
  }

  //add item waste category
  Future<bool> addWasteCategories(
      WasteCategory wasteCategory, String imagePath) async {
    try {
      final storageClient = supabaseClient.storage.from("raw.assets");
      final filename = imagePath.split("/").last;
      final url = await storageClient.upload(filename, File(imagePath));
      final jsonData = wasteCategory.copyWith(imageUrl: url).toJson()
        ..removeWhere((key, value) => value == null);
      print("json: $jsonData");
      final response =
          await supabaseClient.from(path).insert(jsonData).select();
      final data = response as List;
      return data.isNotEmpty;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> deleteWasteCategory(int? idWaste) async {
    return await supabaseClient.from(path).delete().eq('id_waste', idWaste);
  }
}
