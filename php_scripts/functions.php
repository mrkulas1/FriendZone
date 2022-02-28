<?php
// Hold declarations for all database communication functions that can be called
// by Flutter. For now, this will be user authentication, getting a list of events (basic data),
// and getting detailed info about one event.

  function connectDB(){
    //Initializes database
  }

  function authenticate(char(40) email, char(50) password){
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
      return true;
    }
    return false;
  }

  function getFriends(){
   //Returns list of friends with desired information
   //such as name, email, registered events with the exception of password
    
    $dbh = connectDB();
    $statement = $dbh->prepare("Select Email, Name, Introduction, Additional_Contact from User");
    $return = $statement->execute();
    return $return;
    
  }

  function getEvents(){
    
    //returns list of events  
    $dbh = connectDB();
    $statement = $dbh->prepare("Select * from Events");
    $return = $statement->execute();
    return $return
    
  }

  function getEventsDay(timestamp day){
    //Returns events on given day
    //Trevor may need a bit of extra work to figure this out, will come back to it
  }

  function signupEvents(int id, char(40) email, text, comment){
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

  function createFriend(char(40) email, char(100) password, char(100) name, text intro, char(40) contact, tinyint(1) admin){
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
    $statement->bindParam(":admin", admin);
    $result = $statement->execute();
    return "Friend Created Successfully";
  }

  function createEvent(char(40) email, char(100) title, text description, int slots, int category, tinyint(1) reported, timestamp date_created){
   //creates event 
    $dbh = connectDB();
    $statement = $dbh->prepare("SELECT count(*) from Event);
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
