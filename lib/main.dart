import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crud_1/data/services/api_service.dart';
import 'package:crud_1/bloc/coffee_bloc.dart';
import 'package:crud_1/bloc/coffee_event.dart';
import 'package:crud_1/presentation/screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoffeeBloc(ApiService())..add(LoadOrdersEvent()),
      child: MaterialApp(
        title: 'CafeConnect Dashboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4A2C11),
            primary: const Color(0xFF4A2C11),
            surface: const Color(0xFFFFFDF9),
          ),
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}