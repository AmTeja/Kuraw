import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuraw/core/data/model/user.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
class Post with _$Post {
  const factory Post({
    required String id,
    required String title,
    required String content,
    required String userId,
    required String image,
    User? user,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
