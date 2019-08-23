import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'dart:io';

class PDInfo {
  static final PDInfo _singleton = PDInfo._internal();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  factory PDInfo() {
    return _singleton;
  }

  PDInfo._internal();

  Future<String> getDeviceID() async {
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.androidId;
    }
  }

  Future<String> getAppVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> getAppBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }
}
