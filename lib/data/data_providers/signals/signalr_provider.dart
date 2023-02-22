import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/io_client.dart';
import 'package:injectable/injectable.dart';
import 'package:signalr_core/signalr_core.dart';

import '../../../core/environment/app_environment.dart';
import '../../../core/services/auth_service.dart';

@Singleton(scope: 'fullAccess')
class SignalRProvider {
  late String _token;

  @PostConstruct()
  void postConstructInit() async {
    await init(_token);
  }

  HubConnection? _connection;

  bool get isConnected => _connection?.connectionId != null;

  SignalRProvider(AuthService authService) {
    _token = authService.token;
  }

  @disposeMethod
  void dispose() => closeConnection();

  init(String token) async {
    if (isConnected) return;

    final options = HttpConnectionOptions(
      transport: HttpTransportType.webSockets,
      accessTokenFactory: () async => token,
      client:
          IOClient(HttpClient()..badCertificateCallback = (x, y, z) => true),
      logging: (level, message) {
        if (kDebugMode) {
          log(message, name: 'SignalR');
        }
      },
    );

    _connection = HubConnectionBuilder()
        .withUrl(AppEnvironment.signalRUrl, options)
        .build();

    await _connection!.start()?.then((value) {
      if (kDebugMode) {
        log('New instance: Connection established!', name: 'SignalR');
      }
    }).catchError((err) {
      if (kDebugMode) {
        log('New instance: Error while establishing connection : $err',
            name: 'SignalR');
      }
    });
  }

  registerHandler(String methodName, Function(List<dynamic>?) handler) {
    if (_connection == null) {
      log('Unable to register handler for $methodName. Connection is not initialized.',
          name: 'SignalR');
      throw Exception(
          'Unable to register handler for $methodName. Connection is not initialized.');
    }
    _connection!.on(methodName, handler);
  }

  closeConnection() {
    if (isConnected) _connection?.stop();
  }
}
