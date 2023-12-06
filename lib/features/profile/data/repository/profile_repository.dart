import 'package:kuraw/core/data/model/user.dart';
import 'package:kuraw/core/http_client.dart';

class ProfileRepository {
  const ProfileRepository(this._httpClient);

  final HttpClient _httpClient;

  Future<User> getUser(String uid) async {
    final response = await _httpClient.get('/User/$uid');
    return User.fromJson(response.data['data']);
  }
}
