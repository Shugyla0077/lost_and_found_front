import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

String _resolveBaseUrl() {
  // Android эмулятор видит хост-машину как 10.0.2.2; на остальных платформах оставляем localhost.
  if (!kIsWeb && Platform.isAndroid) {
    return 'http://10.0.2.2:8000/api';
  }
  return 'http://127.0.0.1:8000/api';
}

Dio createBackendDio() {
  return Dio(
    BaseOptions(
      baseUrl: _resolveBaseUrl(),
      contentType: 'application/json',
    ),
  );
}