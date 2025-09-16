import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../domain/models/global_plant_model.dart';
import 'global_plant_ds_interface.dart';

class GetGlobalPlantsDS implements IGetGlobalPlantsDS {
  @override
  Future<List<GlobalPlantModel>> getGlobalPlants() async {
    try {
      final jsonString = await rootBundle.loadString('assets/global_plants.json');

      final List<dynamic> rawList = json.decode(jsonString) as List<dynamic>;

      final result = rawList.map((item) => GlobalPlantModel.fromMap(item as Map<String, dynamic>)).toList();

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
