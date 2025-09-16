import 'package:flutter_modular/flutter_modular.dart';
import 'package:poc_geo/app/global_plants_module/presenter/controllers/global_plant_controller.dart';

import 'domain/repositories/global_plant_repository.dart';
import 'domain/repositories/global_plant_repository_interface.dart';
import 'domain/usecases/get_global_plant.dart';
import 'external/data_source/global_plant_ds.dart';
import 'presenter/pages/global_plants_page.dart';

class GeoModule extends Module {
  @override
  final List<Bind> binds = [
    //Controller
    Bind.lazySingleton((i) => GlobalPlantsController(i<IGlobaPlantRepository>())),
    //Usecase
    Bind.lazySingleton((i) => GetGlobalPlant(i<GlobalPlantRepositoryImpl>())),
    //external
    Bind.lazySingleton((i) => GetGlobalPlantsDS()),
    //repository
    Bind.lazySingleton((i) => GlobalPlantRepositoryImpl(i<GetGlobalPlantsDS>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      Modular.initialRoute,
      child: (_, args) => const GlobalPlantsPage(),
    ),
  ];
}
