import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';
import 'app/global_plants_module/domain/models/global_plant_model.dart';
import 'app/global_plants_module/domain/models/polygon_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(GlobalPlantModelAdapter());
  Hive.registerAdapter(PolygonModelAdapter());

  await Hive.openBox<GlobalPlantModel>('global_plants_box');

  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}
