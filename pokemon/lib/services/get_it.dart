import 'package:get_it/get_it.dart';
import 'package:pokemon/services/http_service.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton<HttpService>(HttpService());
}
