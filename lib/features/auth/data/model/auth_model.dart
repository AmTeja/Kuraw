class AuthModel {
  final String? model;

  AuthModel({this.model});

  factory AuthModel.fromJson(Map<String, Object?> json) {
    return AuthModel(
      model: json['token']?.toString(),
    );
  }
}
