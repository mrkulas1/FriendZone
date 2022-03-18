/// Class to handle JSON serialization/deserialization for a ForeignUser object

import '../foreign_user.dart';
import 'json_builder.dart';
import 'json_list_builder.dart';

class ForeignUserBuilder extends JsonBuilder<ForeignUser>
    with JsonListBuilder<ForeignUser> {
  @override
  Map<String, dynamic> toJson(ForeignUser obj) {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  ForeignUser fromJson(Map<String, dynamic> json) {
    return ForeignUser(
        email: json["email"] ?? "",
        name: json["name"] ?? "",
        introduction: json["introduction"] ?? "",
        contact: json["additional_contact"] ?? "");
  }

  @override
  List listToJson(List<ForeignUser> obj) {
    // TODO: implement listToJson
    throw UnimplementedError();
  }

  @override
  List<ForeignUser> listFromJson(List json) {
    List<ForeignUser> users = [];

    for (var user in json) {
      users.add(fromJson(user));
    }

    return users;
  }
}
