<?php
// Hold declarations for all database communication functions that can be called
// by Flutter. For now, this will be user authentication, getting a list of events (basic data),
// and getting detailed info about one event.

  function connectDB(){
    //Initializes database
    $config = parse_ini_file("db.ini");
    $dbh = new PDO($config["dsn"], $config["username"], $config["password"]);
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    return $dbh;
  }

  function errorReturn(String $message) {
    return array("error" => $message);
  }

  /*
  Return Codes:
  0 - Success
  1 - User DNE
  2 - Wrong Password
  3 - Locked Out
  4 - Error
  */

  function eliminateSpaces($str){

    $newEmail = "";

    for ($x = 0; $x < strlen(str); $x++){
      $letter = substr($str, $x, 1);
      if($letter != " ") {
        $newEmail = $newEmail . letter;
      }
    }
    return $newEmail;
  }

  function Auth(String $email, String $password) {
    //Authenticates User for login function
    try{
      $dbh = connectDB();



      $email = eliminateSpaces($email);
      // Determine whether user exists
      $statement = $dbh->prepare("select count(*) from User where email = :email");
      $statement->bindParam(":email", $email);
      $result = $statement->execute();
      $row = $statement->fetch();
      if ($row[0] == 0)
      {
        $dbh = null;
        return 1;
      }

      // Determine whether user is locked out - TODO

      // Determine that the password is correct
      $statement = $dbh->prepare("select count(*) from User where email = :email and password = sha2(:password, 256)");
      $statement->bindParam(":email", $email);
      $statement->bindParam(":password", $password);
      $result = $statement->execute();
      $row = $statement->fetch();
      $dbh = null;

      if ($row[0] == 0) {
        return 2;
      }


      return 0;
    }
    catch (PDOException $exception){
        //echo 'Errors Occurred in Auth Function function.php';
        //echo $exception->getMessage();
        return 4;
    }
  }


  function Get_User(String $email) {
    //Returns the user info from the user with the given email
    try {
      $dbh = connectDB();
      $email = eliminateSpaces($email);
      $statement = $dbh->prepare("SELECT email, name, introduction, additional_contact from User where email = :email");
      $statement->bindParam(":email", $email);
      $result = $statement->execute();
      $row = $statement->fetch(PDO::FETCH_ASSOC);

      $dbh = null;

      if (empty($row)) {
        return errorReturn("No user with this email");
      }

      return $row;
    }
    catch (PDOException $exception){
      return errorReturn($exception->getMessage());
    }
  }

  function Create_User(String $email, String $password, String $name, String $intro, String $contact){
    //Creates user in DB, then return that user
    try {
      $dbh = connectDB();
      $email = eliminateSpaces($email);
      $statement = $dbh->prepare("SELECT count(*) from User where email = :email");
      $statement->bindParam(":email", $email);
      $result = $statement->execute();
      $row = $statement->fetch();

      if($row[0] > 0){
        $dbh = null;
        return errorReturn("User Already Exists");
      }


      $statement = $dbh->prepare("INSERT INTO User (email, password, name, introduction, additional_contact)
        values(:email, sha2(:password, 256), :name, :intro, :contact)");
      $statement->bindParam(":email", $email);
      $statement->bindParam(":password", $password);
      $statement->bindParam(":name", $name);
      $statement->bindParam(":intro", $intro);
      $statement->bindParam(":contact", $contact);
      $result = $statement->execute();

      $dbh = null;

      return Get_User($email);
    }
    catch (PDOException $exception){
      return errorReturn($exception->getMessage());
    }
  }

  function Get_Friends(){
    //Returns list of friends with desired information
    //such as name, email, registered events with the exception of password
    try {
      $dbh = connectDB();
      $statement = $dbh->prepare("Select email, name, introduction, additional_contact from User");
      $return = $statement->execute();

      $dbh = null;

      return $return;
    }

    catch (PDOException $exception){
      echo 'Errors Occurred in Get_Friends Function function.php';
      echo $exception->getMessage();
    }

  }

  function Get_All_Events(){
    // Returns list of events with the basic info
    // TODO: maybe filter these to only events that are in the future?
    try {
      $dbh = connectDB();

      $statement = $dbh->prepare("Select id, email, title, time, location, slots, category from Event");
      $return = $statement->execute();
      $rows = $statement->fetchAll(PDO::FETCH_ASSOC);

      $dbh = null;

      return $rows;
    } catch (PDOException $exception){
      return errorReturn($exception->getMessage());
    }
  }

  function Get_Detailed_Event(int $id){
    //Returns detailed information from specific event
    try {
      $dbh = connectDB();
      $statement = $dbh->prepare("Select * from Event where id = :id");
      $statement->bindParam(":id", $id);
      $result = $statement->execute();
      $row = $statement->fetch(PDO::FETCH_ASSOC);

      $dbh = null;

      if (empty($row)) {
        return errorReturn("No event with this ID");
      }

      return $row;
    }
    catch (PDOException $exception){
      return errorReturn($exception->getMessage());
    }
  }

  function Create_Event(String $email, String $title, String $description,
    String $time, String $location, int $slots, int $category) {
    //creates event, then returns its detailed info
    // NOTE - Commenting out time for now since String - DATETIME will be weird
    try {
      $dbh = connectDB();

      $statement = $dbh->prepare("INSERT INTO Event(email, title, description, time, location, slots, category)
        values(:email, :title, :description, :time, :location, :slots, :category)");
      $statement->bindParam(":email", $email);
      $statement->bindParam(":title", $title);
      $statement->bindParam(":description", $description);
      $statement->bindParam(":time", $time);
      $statement->bindParam(":location", $location);
      $statement->bindParam(":slots", $slots);
      $statement->bindParam(":category", $category);
      $result = $statement->execute();

      // This is potentially prone to error - need testing,
      // probably want to wrap in transaction to avoid race condition
      $statement = $dbh->prepare("SELECT max(id) from Event");
      $result = $statement->execute();
      $eventID = ( $statement->fetch() )[0];

      $dbh = null;
      return Get_Detailed_Event($eventID);
    }
    catch (PDOException $exception){
      return errorReturn($exception->getMessage());
    }
  }

  // Making this to quickly throw something together
  function Update_Event(int $id, String $title, String $description,
    String $time, String $location, int $slots, int $category) {

    try {
      $dbh = connectDB();

      $statement = $dbh->prepare("SELECT COUNT(*) FROM Event WHERE id = :id");
      $statement->bindParam(":id", $id);
      $result = $statement->execute();
      $row = $statement->fetch();

      if ($row[0] == 0) {
        $dbh = null;
        return errorReturn("No event with this ID");
      }

      $statement = $dbh->prepare("UPDATE Event SET title = :title, description = :description,
        time = :time, location = :location, slots = :slots, category = :category WHERE id = :id");
      $statement->bindParam(":id", $id);
      $statement->bindParam(":title", $title);
      $statement->bindParam(":description", $description);
      $statement->bindParam(":time", $time);
      $statement->bindParam(":location", $location);
      $statement->bindParam(":slots", $slots);
      $statement->bindParam(":category", $category);
      $result = $statement->execute();

      $dbh = null;

      return Get_Detailed_Event($id);
    } catch (PDOException $exception) {
      return errorReturn($exception->getMessage());
    }
  }


//  function Update_Event(int $id, String $param, String $newVal){
//    //Updates Event parameter param, sets to newVal
//    // I like this idea - maybe weakly type the $param/$newVal, then make it an associative array
//    // of $param -> $newval to build a SQL statement with multiple ANDs?
//    try {
//      $dbh = connectDB();
//      $statement = $dbh->prepare("UPDATE Event where id = :id set :param = :newVal");
//      $statement->bindParam(":id", $id);
//      $statement->bindParam(":param", $param);
//      $statement->bindParam(":newVal", $newVal);
//      $result = $statement->execute();

//      return $result;
//    }

//    catch (PDOException $exception){
//      echo 'Errors Occurred in Update_Event Function w/ String param function.php';
//      echo $exception->getMessage();
//    }
//  }

  // Commenting out since php does not like the repeat function name
  // function Update_Event(int $id, String $param, int $newVal){
  //   //Updates Event parameter param, sets to newVal, same funcation, just takes input int
  //   //rather than string for value
  //   try {
  //     $dbh = connectDB();
  //     $statement = $dbh->prepare("Update Event where id = :id set :param = :newVal");
  //     $statement->bindParam(":id", $id);
  //     $statement->bindParam(":param", $param);
  //     $statement->bindParam(":newVal", $newVal);
  //     $result = $statement->execute();

  //     return $result;
  //   }
  //   catch (Exception $exception){
  //     echo 'Errors Occurred in Update_Event Function w/ int param function.php';
  //     echo $exception->getMessage();
  //   }
  // }

  function getEventsDay(String $day){
    //Returns events on given day
    //Trevor may need a bit of extra work to figure this out, will come back to it
  }

  function Join_Event(int $id, String $email, String $comment){
    try {
      $dbh = connectDB();

      $statement = $dbh->prepare("SELECT Count(id) FROM Joins WHERE id = :id AND email = :email");
      $statement->bindParam(":id", $id);
      $statement->bindParam(":email", $email);
      $statement->execute();
      $result = $statement->fetchColumn(0);

      // Check if user already sign up for an event
      if($result > 0){
        $statement = $dbh->prepare("UPDATE Joins set comment = :comment WHERE id = :id AND email = :email");
        $statement->bindParam(":id", $id);
        $statement->bindParam(":email", $email);
        $statement->bindParam(":comment", $comment);
        $statement->execute();
        return 1; //"Updated Event Comment";
      }


      $statement = $dbh->prepare("SELECT Count(id) FROM Joins WHERE id = :id");
      $statement->bindParam(":id", $id);
      $statement->execute();
      $result1 = $statement->fetchColumn(0);

      $statement = $dbh->prepare("SELECT slots FROM Event WHERE id = :id");
      $statement->bindParam(":id", $id);
      $statement->execute();
      $result2 = $statement->fetchColumn(0);

      // Check if there are any slots left.
      if($result1 == $result2){
        return errorReturn("Event has no remaining slots");
      } else {
        $statement = $dbh->prepare("INSERT INTO Joins values(:id, :email, :comment)");
        $statement->bindParam(":id", $id);
        $statement->bindParam(":email", $email);
        $statement->bindParam(":comment", $comment);
        $statement->execute();
        return 1; //"Event Joined Successfully";
      }
    }
    catch (PDOException $exception){
      //echo 'Errors Occurred in Join_Event Function function.php';
      return errorReturn($exception->getMessage());
    }
  }

  function Leave_Event(int $id, String $email){
    try{
      $dbh = connectDB();

      $statement = $dbh->prepare("SELECT Count(*) FROM Joins WHERE id = :id AND email = :email");
      $statement->bindParam(":id", $id);
      $statement->bindParam(":email", $email);
      $statement->execute();
      $result = $statement->fetchColumn(0);
      // Check if user is signed up to the event
      if ($result == 0) {
        return 1;
      }

      $statement = $dbh->prepare("DELETE FROM Joins WHERE id = :id AND email = :email");
      $statement->bindParam(":id", $id);
      $statement->bindParam(":email", $email);
      $result = $statement->execute();
      return 1; //"Event leave successfully";
    }
    catch (PDOException $exception) {
      //echo 'Errors Occurred in Leave_Event Function function.php';
      return errorReturn($exception->getMessage());
    }
  }

  function Get_Event_Attendees(int $id){
   //Returns list of attendees of particular event
    try{
      $dbh = connectDB();
      $statement = $dbh->prepare("SELECT * from Joins where id = :id");
      $statement->bindParam(":id", $id);
      $statement->execute();
      $row = $statement->fetchall(PDO::FETCH_ASSOC);
      return $row;
    }
    catch (PDOException $exception){
      //echo 'Errors Occurred in Get_Event_Attendees Function function.php';
      return errorReturn($exception->getMessage());
    }
  }
?>
