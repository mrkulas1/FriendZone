import '../current_user.dart';
import 'json_builder.dart';

/// Class to handle JSON serialization/deserialization for a CurrentUser object
class CurrentUserBuilder extends JsonBuilder<CurrentUser> {
  @override
  Map<String, dynamic> toJson(CurrentUser obj) {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  CurrentUser fromJson(Map<String, dynamic> json) {
    CurrentUser user = CurrentUser(json["email"] ?? "", json["name"] ?? "",
        json["introduction"] ?? "", json["additional_contact"] ?? "");

    if (json.containsKey("token")) {
      user.setToken(json["token"]);
    }

    if (json.containsKey("admin")) {
      if (int.parse(json["admin"]) == 1) {
        user.makeAdmin();
      }
    }

    return user;
  }
}
