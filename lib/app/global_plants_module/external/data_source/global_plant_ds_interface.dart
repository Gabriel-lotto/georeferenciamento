import '../../domain/models/global_plant_model.dart';

abstract class IGetGlobalPlantsDS {
  Future<List<GlobalPlantModel>> getGlobalPlants();
}
