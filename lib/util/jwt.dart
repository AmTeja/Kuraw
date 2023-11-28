//
import 'dart:convert';

String uuidFromJWT(String? token) {
  if (token == null) return '';

  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  final payload = parts[1];
  final normalized = base64Url.normalize(payload);
  final resp = utf8.decode(base64Url.decode(normalized));
  final map = json.decode(resp);
  return map['userId'];
}
