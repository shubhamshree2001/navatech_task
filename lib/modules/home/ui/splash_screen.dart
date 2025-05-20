import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navatech_task/data/routes/app_routes.dart';
import 'package:navatech_task/modules/home/bloc/home_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool hasNavigated = false;

  @override
  void initState() {
    super.initState();
    final HomeCubit homeCubit = context.read<HomeCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await insideInitCalledFnc(homeCubit);
    });
    Future.delayed(const Duration(milliseconds: 5500), () {
      if (!hasNavigated && mounted) {
        _navigate();
      }
    });
  }

  Future<void> insideInitCalledFnc(HomeCubit homeCubit) async {
    await Future.wait([homeCubit.loadAndCacheAlbumsAndPhotos()]);
    if (!hasNavigated && mounted) {
      _navigate();
    }
  }

  void _navigate() async {
    if (hasNavigated || !mounted) return;
    hasNavigated = true;
    Navigator.pushReplacementNamed(context, Routes.homeScreen);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'NavaTech',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
