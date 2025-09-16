import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:poc_geo/app/global_plants_module/geo_module.dart';

import 'core/api/dio/dio_impl.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => Dio()),
    Bind.lazySingleton((i) => DioNetworkImpl(i<Dio>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: GeoModule()),
  ];
}
