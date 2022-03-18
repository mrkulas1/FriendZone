/// Class representing a User that is not the one currently logged into the app.
/// Contains only public data for the User.

class ForeignUser {
  String email;
  String name;
  String introduction;
  String contact;

  ForeignUser(
      {required this.email,
      required this.name,
      required this.introduction,
      required this.contact});
}
