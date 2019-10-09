import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'dart:io';

abstract class PackageDeviceInfo {
  Future<String> getDeviceID();
  Future<String> getAppVersionNumber();
  Future<String> getAppBuildNumber();
}

class PackageDeviceInfoImplementation extends PackageDeviceInfo {
  // static final PDInfo _singleton = PDInfo._internal();
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  // factory PDInfo() {
  //   return _singleton;
  // }

  // PDInfo._internal();
  @override
  Future<String> getDeviceID() async {
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.androidId;
    }
  }

  @override
  Future<String> getAppVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Future<String> getAppBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }
}
