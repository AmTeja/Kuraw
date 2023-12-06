import 'package:kuraw/core/http_client.dart';
import 'package:kuraw/features/home/data/dto/post_dto.dart';
import 'package:kuraw/features/home/data/model/post.dart';

class PostRepository {
  PostRepository(this._client);

  final HttpClient _client;

  Future<List<Post>> fetchPosts([int numberOfPosts = 0]) async {
    final response = await _client.get('/Posts?numberOfPosts=$numberOfPosts');

    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((rawPost) => Post.fromJson(rawPost)).toList();
    } else {
      final data = response.data as 
      throw Exception('error fetching posts');
    }
  }

  Future<Post> createPost(PostDTO post, String userId) async {
    final response = await _client.post('/Posts',
        body: post.toJson()..addAll({'userId': userId}));

    if (response.statusCode == 201) {
      return Post.fromJson(response.data);
    } else {
      throw Exception('error creating post');
    }
  }
}
