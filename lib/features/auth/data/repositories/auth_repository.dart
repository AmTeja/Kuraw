import 'dart:async';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:kuraw/core/http_client.dart';

enum UserAuthenticationStatus {
  unknown,
  signedIn,
  signedOut,
}

class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthRepo {
  AuthRepo(this._client, this._storage) {
    _checkToken();
  }

  final HttpClient _client;
  final FlutterSecureStorage _storage;

  String? accessToken;
  String? _refreshToken;

  Stream<UserAuthenticationStatus> get status {
    return _client.authenticationStatus.map((status) {
      switch (status) {
        case AuthenticationStatus.authenticated:
          return UserAuthenticationStatus.signedIn;
        case AuthenticationStatus.unauthenticated:
          return UserAuthenticationStatus.signedOut;
        case AuthenticationStatus.initial:
          return UserAuthenticationStatus.unknown;
      }
    });
  }

  Future<OAuth2Token?> get token async => await _client.token;

  Future<void> _checkToken() async {
    final token = await _storage.read(key: 'token');
    final refreshToken = await _storage.read(key: 'refreshToken');
    if (token != null && refreshToken != null) {
      accessToken = token;
      _refreshToken = refreshToken;
      _client.onAuthenticated({
        'token': {
          'accessToken': token,
          'refreshToken': refreshToken,
        }
      });
    }
  }

  Future<void> login(String username, String password) async {
    final response = await _client.post('/Auth/login', body: {
      'username': username,
      'password': password,
    });
    final body = response.data;
    final data = response.data['data'];

    if (response.statusCode != 200) {
      throw AuthException(body['message']);
    }
    await _storage.write(key: 'token', value: data['token']['accessToken']);
    await _storage.write(
        key: 'refreshToken', value: data['token']['refreshToken']);
    _client.onAuthenticated(data);
  }

  Future<void> register(
      String username, String password, String email, String profilePic) async {
    final response = await _client.post('/Auth/register', body: {
      'username': username,
      'password': password,
      'email': email,
      'profilePicture': profilePic,
      'profileName': username,
    });
    final body = response.data;
    final data = response.data['data'];

    if (response.statusCode != 200) {
      throw AuthException(body['message']);
    }
    await _storage.write(key: 'token', value: data['token']['accessToken']);
    await _storage.write(
        key: 'refreshToken', value: data['token']['refreshToken']);
    _client.onAuthenticated(data);
  }

  void logOut() async {
    try {
      final response = await _client.post('/Auth/logout', body: {
        'refreshToken': _refreshToken,
        'accessToken': accessToken,
      });

      if (response.statusCode == 200) {
        await _storage.delete(key: 'token');
        await _storage.delete(key: 'refreshToken');
        _client.onUnauthenticated();
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
