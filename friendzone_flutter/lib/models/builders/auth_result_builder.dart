/// Class to handle JSON serialization/deserialization for an AuthResult object

import '../auth_result.dart';
import 'json_builder.dart';

class AuthResultBuilder extends JsonBuilder<AuthResult> {
  @override
  Map<String, dynamic> toJson(AuthResult obj) {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  AuthResult fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }
}
