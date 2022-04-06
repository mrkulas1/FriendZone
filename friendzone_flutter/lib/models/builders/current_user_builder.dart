/// Class to handle JSON serialization/deserialization for a CurrentUser object

import '../current_user.dart';
import 'json_builder.dart';

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
    return user;
  }
}
