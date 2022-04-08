/// Class to represent an Event that is pulled off of the database.

class Event {
  int id;
  String userEmail;
  String title;
  String time;
  String location;
  int slots;
  String category;
  String subCat;

  bool _detailed = false;
  String? description;
  bool? reported;
  String? dateCreated;

  Event(
      {required this.id,
      required this.userEmail,
      required this.title,
      required this.time,
      required this.location,
      required this.slots,
      required this.category,
      required this.subCat,
      this.description,
      this.reported,
      this.dateCreated});

  bool detailed() {
    return _detailed;
  }

  void makeDetailed(String desc, bool rep, String date) {
    description = desc;
    reported = rep;
    dateCreated = date;
    _detailed = true;
  }
}
