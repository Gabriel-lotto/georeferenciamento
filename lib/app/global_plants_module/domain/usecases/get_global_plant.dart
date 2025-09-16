import 'package:poc_geo/app/global_plants_module/domain/models/global_plant_model.dart';

import '../repositories/global_plant_repository_interface.dart';

abstract class IGetJsonPlaceholder {
  Future<List<GlobalPlantModel>> call();
}

class GetGlobalPlant implements IGetJsonPlaceholder {
  final IGlobaPlantRepository repository;

  GetGlobalPlant(this.repository);

  @override
  Future<List<GlobalPlantModel>> call() async {
    var result = await repository.getGlobalPlants();
    return result;
  }
}
