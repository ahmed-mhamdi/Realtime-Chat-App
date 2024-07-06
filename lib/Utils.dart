import 'package:chat_app_material3/firebase_options.dart';
import 'package:chat_app_material3/services/alert_service.dart';
import 'package:chat_app_material3/services/auth_service.dart';
import 'package:chat_app_material3/services/db_service.dart';
import 'package:chat_app_material3/services/media_service.dart';
import 'package:chat_app_material3/services/navigation_service.dart';
import 'package:chat_app_material3/services/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> registreServices() async {
  // final GetIt getIt = GetIt.instance;
  GetIt.instance.registerSingleton<AuthService>(AuthService());
  GetIt.instance.registerSingleton<NavigationService>(NavigationService());
  GetIt.instance.registerSingleton<AlertService>(AlertService());
  GetIt.instance.registerSingleton<MediaService>(MediaService());
  GetIt.instance.registerSingleton<StorageService>(StorageService());
  GetIt.instance.registerSingleton<DbService>(DbService());
}

String generateChatID({required String uid1, required String uid2}) {
  List uids = [uid1, uid2];
  uids.sort();
  String chatID =
      uids.fold("", (previousValue, element) => "$previousValue$element");
  return chatID;
}

T getService<T extends Object>() {
  return GetIt.instance.get<T>();
}
