import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hiddengems_flutter/pages/home_page.dart';
import 'package:flutter/services.dart';
import 'package:hiddengems_flutter/services/auth.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:hiddengems_flutter/services/storage.dart';

final GetIt getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<Auth>(AuthImplementation(), signalsReady: true);
  getIt.registerSingleton<Modal>(ModalImplementation(), signalsReady: true);
  getIt.registerSingleton<Storage>(StorageImplementation(), signalsReady: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hidden Gems',
      theme: ThemeData(
        brightness: Brightness.light,
        accentColor: Colors.black,
        primaryColor: Colors.black,
        fontFamily: 'Montserrat',
      ),
      home: HomePage(),
    );
  }
}
