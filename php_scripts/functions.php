<?php
// Hold declarations for all database communication functions that can be called
// by Flutter. For now, this will be user authentication, getting a list of events (basic data),
// and getting detailed info about one event.

  function connectDB(){
    //Initializes database
    //Find .ini file or hardcode the dbname, username, password
    //$config = parse_ini_file("db.ini");
	  //$dbh = new PDO($config['dsn'], $config['username'], $config['password']);
    $dbh = new PDO("team3_frien", "team3_frien_rw", "3141*Database");
	  $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	  return $dbh;
  }

  function Auth(String email, String password){
    //Authenticates User for login function
    
    $dbh = connectDB();
    $statement = $dbh->prepare("sha2(:password, 256)");
    $statement->bindParam(":password", password);
    $encPassword = $statement->execute();
    
    $statement = $dbh->prepare("select count(*) from User where Email = :email and Password = :encPassword");
    $statement->bindParam(":email", email);
    $statement->bindParam(":encPassword", $encPassword);
    $result = $statement->execute();
    
    if($result == 1){
      $statement = $dbh->prepare("select Email, Name, Introduction, Additional_Contact, Admin from User where Email = :email");
      $statement->bindParam(":email", email);
      $result = $statement->execute();
      return $result;
      //return true;
    }
    return null;
    //return false
  }

  function getFriends(){
   //Returns list of friends with desired information
   //such as name, email, registered events with the exception of password
    
    $dbh = connectDB();
    $statement = $dbh->prepare("Select Email, Name, Introduction, Additional_Contact from User");
    $return = $statement->execute();
    return $return;
    
  }

  function Get_All_Events(){
    
    //returns list of events  
    
    $dbh = connectDB();
    $statement = $dbh->prepare("Select * from Events");
    $return = $statement->execute();
    return $return
    
  }

  function Get_Detailed_Event(int Id){
    
    //Returns detailed information from specific event
    
    $dbh = connectDB();
    $statement = $dbh->prepare("Select * from Events where Id = :Id");
    $statement->bindParam(":Id", Id);
    $result = $statement->execute();
    return $result;
    
  }

  function getEventsDay(String day){
    //Returns events on given day
    //Trevor may need a bit of extra work to figure this out, will come back to it
  }

  function Join_Event(int id, String email, String comment){
    // Signs up user for desired event
    
    $dbh = connectDB();
    
    $statement = $dbh->prepare("Select count(*) from Joins where Id = :id");
    $statement->bindParam(":id", id);
    $result1 = $statment->execute();
    
    $statement = $dbh->prepare("Select Slots from Event where Id = :id");
    $statement->bindParam(":id", id);
    $result2 = $statement->execute();
    
    if($result1 == $result2){
      return "Event has no remaining slots";
    }
    
    $statement = $dbh->prepare("Select count(*) from Joins where Id = :id and Email = :email");
    $statement->bindParam(":id", id);
    $statement->bindParam(":email", email);
    $result = $statement->execute();
    
    if($result > 0){
      $statement = $dbh->prepare("Update Joins where Id = :id and Email = :email set Comment = :comment");
      $statement->bindParam(":id", id);
      $statement->bindParam(":email", email);  
      $statement->bindParam(":comment", comment);
      $statement->execute
      return "Updated Event Comment"; 
    }
    else {
      $statement = $dbh->prepare("Insert into Joins values(:id, :email, :comment)");
      $statement->bindParam(":id", id);
      $statement->bindParam(":email", email);  
      $statement->bindParam(":comment", comment);
      $statement->execute
      return "Event Joined"; 
    }
  }

  function Get_Event_Attendees(int Id){
   //Returns list of attendees of particular event
    $dbh = connectDB();
    $statement = $dbh->prepare("Select * from Joins where Id = :Id");
    $statement->bindParam(":Id", Id);
    $result = $statement->execute();
    return $result;
    
  }

  function Create_User(String email, String password, String) name, String intro, String contact, int admin){
    //creates user in DB 
    $dbh = connectDB();
    $statement = $dbh->prepare("SELECT count(*) from User where Email = email");
    $result = $statement->execute();
    
    if($result > 0){
       return "Friend Already Exists";
    }
  
    $statement = $dbh->preare("sha2(:password, 256)");
    $statement->bindParam(":password", password);
    $result = $statement->execute();
    $encPassword = $result;
    
    $statement = $dbh->prepare("Insert into User values(:email, :encPassword, :name, :intro, :contact, :admin)");
    $statement->bindParam(":email", email);
    $statement->bindParam(":endPassword", $encPassword);
    $statement->bindParam(":name", name);
    $statement->bindParam(":intro", intro);
    $statement->bindParam(":contact", contact);
    $statement->bindParam(":admin", admin);
    $result = $statement->execute();
    return "Friend Created Successfully";
  }

  function Get_User(String email){
    //Returns a given user
    $dbh = connectDB();
    $statement = $dbh->prepare("Select Email, Name, Intro, Contact from User where Email = :email");
    $statement->bindParam(":email", email);
    $result = $statement->execute();
    return $result;

  }

  function Create_Event(String email, String title, String description, int slots, int category, int reported, String date_created) {
   //creates event 
    $dbh = connectDB();
    $statement = $dbh->prepare("SELECT count(*) from Event");
    $eventID = $statement->execute();
    $statement = $dbh->prepare("Insert into Event values(:eventID, :title, :description, :slots, :category, :reported, :date_created)");
    $statement->bindParam(":eventID", $eventID);
    $statement->bindParam(":title", title);
    $statement->bindParam(":description", description);
    $statement->bindParam(":slots", slots);
    $statement->bindParam(":category", category);
    $statement->bindParam(":reported", reported);
    $statement->bindParam(":date_created", date_created);
    $result = $statement->execute();
    return "Event Created Successfully";
  }
?>
