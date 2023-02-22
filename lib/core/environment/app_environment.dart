import 'package:flutter/foundation.dart';

abstract class AppEnvironment {
  static const _prodUrl = '';
  static const _devUrl = '';

  static const _url = kDebugMode ? _devUrl : _prodUrl;

  static const apiUrl = '$_url/api/v1';
  static const signalRUrl = '$_url/hubs/notification';
}
