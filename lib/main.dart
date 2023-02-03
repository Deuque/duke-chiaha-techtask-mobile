import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_task/repository/app_repository.dart';
import 'package:tech_task/repository/app_repository_impl.dart';
import 'package:tech_task/routes.dart';

void main() {
  final repository = AppRepositoryImpl(
      'https://lb7u7svcm5.execute-api.ap-southeast-1.amazonaws.com/dev');
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final AppRepository repository;

  const MyApp({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => repository,
      child: MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.light,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              fixedSize: const Size.fromHeight(56),
              textStyle: const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        initialRoute: Routes.home,
        routes: Routes.generateRoutes(),
      ),
    );
  }
}
