import '../../domain/repositories/global_plant_repository_interface.dart';
import '../../external/data_source/global_plant_ds_interface.dart';
import '../models/global_plant_model.dart';

class GlobalPlantRepositoryImpl implements IGlobaPlantRepository {
  final IGetGlobalPlantsDS datasource;

  GlobalPlantRepositoryImpl(this.datasource);

  @override
  Future<List<GlobalPlantModel>> getGlobalPlants() async {
    try {
      final plantas = await datasource.getGlobalPlants();
      return plantas;
    } catch (e) {
      rethrow;
    }
  }
}
