import 'package:kuraw/core/data/model/user.dart';
import 'package:kuraw/core/http_client.dart';

class UserRepository {
  const UserRepository(this._httpClient);

  final HttpClient _httpClient;

  Future<User> getUser(String uuid) async {
    final response = await _httpClient.get('/User/$uuid');
    return User.fromJson(response.data['data']);
  }
}
