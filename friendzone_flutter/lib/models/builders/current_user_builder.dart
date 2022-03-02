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
    return CurrentUser(
        email: json["email"],
        name: json["name"],
        introduction: json["introduction"],
        contact: json["additional_contact"]);
  }
}
