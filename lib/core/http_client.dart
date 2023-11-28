import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HttpClient {
  HttpClient._internal(
    this._dio,
  );

  static final HttpClient _instance = HttpClient._internal(
    Dio(BaseOptions(
      baseUrl: 'https://192.168.29.175:7164/',
      validateStatus: (status) {
        return status! < 500;
      },
    ))
      ..interceptors.addAll(
          [PrettyDioLogger(responseBody: true, requestBody: true), _fresh]),
  );

  factory HttpClient() {
    return _instance;
  }

  static final _fresh = Fresh.oAuth2(
      tokenStorage: InMemoryTokenStorage<OAuth2Token>(),
      refreshToken: (token, client) async {
        log('refreshing token');
        final response = await client.post(
          '/Auth/refresh-token',
          data: {
            'refreshToken': token?.refreshToken,
            'accessToken': token?.accessToken,
          },
        );
        return tokenFromJson(response.data['data']);
      });
  final Dio _dio;

  static OAuth2Token tokenFromJson(Map<String, dynamic> data) {
    final token = data['token'];
    return OAuth2Token(
      accessToken: token['accessToken'],
      refreshToken: token['refreshToken'],
    );
  }

  Stream<AuthenticationStatus> get authenticationStatus =>
      _fresh.authenticationStatus;

  Future<OAuth2Token?> get token async => await _fresh.token;

  void onAuthenticated(Map<String, Object?> json) async {
    final token = tokenFromJson(json);
    await _fresh.setToken(token);
  }

  void onUnauthenticated() {
    _fresh.clearToken();
  }

  // Methods
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParams,
  }) {
    return _dio.get(
      path,
      queryParameters: queryParams,
    );
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic>? body,
  }) {
    return _dio.post(
      path,
      data: body,
    );
  }

  Future<Response> put(
    String path,
    Map<String, dynamic> body,
  ) {
    return _dio.put(
      path,
      data: body,
    );
  }

  Future<Response> delete(
    String path,
    Map<String, dynamic> body,
  ) {
    return _dio.delete(
      path,
      data: body,
    );
  }
}
