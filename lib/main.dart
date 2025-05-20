import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:navatech_task/data/routes/app_routes.dart';
import 'package:navatech_task/modules/home/bloc/home_cubit.dart';
import 'package:navatech_task/services/get_it_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await setup();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const NavaTechApp());
}

class NavaTechApp extends StatelessWidget {
  const NavaTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (BuildContext context) => HomeCubit())],
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        designSize: const Size(360, 800),
        enableScaleText: () => false,
        builder: (context, child) {
          return MaterialApp(
            title: 'Nava Tech',
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.splashScreen,
            routes: Routes.routes,
          );
        },
      ),
    );
  }
}
