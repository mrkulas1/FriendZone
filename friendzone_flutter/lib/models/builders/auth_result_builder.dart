/// Class to handle JSON serialization/deserialization for an AuthResult object

import 'package:friendzone_flutter/models/builders/current_user_builder.dart';

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
    AuthStatus status;

    switch (json["status"]) {
      case 0:
        status = AuthStatus.valid;
        break;
      case 1:
        status = AuthStatus.noUser;
        break;
      case 2:
        status = AuthStatus.badCredentials;
        break;
      case 3:
        status = AuthStatus.lockedOut;
        break;
      case 4:
        status = AuthStatus.internalError;
        break;
      default:
        status = AuthStatus.internalError;
        break;
    }

    AuthResult result = AuthResult(status: status, token: json["token"] ?? "");

    if (json.containsKey("user")) {
      result.setUser(CurrentUserBuilder().fromJson(json["user"]));
    }

    return result;
  }
}
