import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuraw/features/home/data/model/post.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String username,
    required String email,
    required String bio,
    required String profilePicture,
    required String profileName,
    required List<Post> posts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
