import 'package:mocktail/mocktail.dart';
import 'package:tech_task/repository/app_repository.dart';
import 'package:http/http.dart' as http;

class MockAppRepository extends Mock implements AppRepository {}

class MockHttpClient extends Mock implements http.Client {}
