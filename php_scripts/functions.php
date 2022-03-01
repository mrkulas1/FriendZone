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

  function Auth(String $email, String $password){
    //Authenticates User for login function
    

    try{ 
      $dbh = connectDB();
      $statement = $dbh->prepare("sha2(:password, 256)");
      $statement->bindParam(":password", password);
      $encPassword = $statement->execute();
      
      $statement = $dbh->prepare("select count(*) from User where email = :email and password = :encPassword");
      $statement->bindParam(":email", email);
      $statement->bindParam(":encPassword", $encPassword);
      $result = $statement->execute();
      
      if($result == 1){
        $statement = $dbh->prepare("select email, name, introduction, additional_contact, admin from User where email = :email");
        $statement->bindParam(":email", email);
        $result = $statement->execute();
        return $result;

      } 
      catch (Exception $exception){
        echo 'Errors Occurred in Auth Function function.php';
        echo $exception->getMessage();
      }
      //return true;
    }
    return null;
    //return false
  }

  function Get_Friends(){
   //Returns list of friends with desired information
   //such as name, email, registered events with the exception of password
    try {
      $dbh = connectDB();
      $statement = $dbh->prepare("Select email, name, introduction, additional_contact from User");
      $return = $statement->execute();
      return $return;
    } 
  
    catch (Exception $exception){
      echo 'Errors Occurred in Get_Friends Function function.php';
      echo $exception->getMessage();
    }
    
  }

  function Get_All_Events(){
    
    //returns list of events  
    try {
    $dbh = connectDB();
    $statement = $dbh->prepare("Select * from Events");
    $return = $statement->execute();
    return $return
    } 
  catch (Exception $exception){
    echo 'Errors Occurred in Get_All_Events() Function function.php';
    echo $exception->getMessage();
    }
  }

  function Get_Detailed_Event(int $id){
    
    //Returns detailed information from specific event
    try {
      $dbh = connectDB();
      $statement = $dbh->prepare("Select * from Events where id = :id");
      $statement->bindParam(":id", id);
      $result = $statement->execute();
      return $result;
    } 
    catch (Exception $exception){
      echo 'Errors Occurred in Get_Detailed_Events Function function.php';
      echo $exception->getMessage();
    }
    
  }

  function getEventsDay(String $day){
    //Returns events on given day
    //Trevor may need a bit of extra work to figure this out, will come back to it
  }

  function Join_Event(int $id, String $email, String $comment){
    // Signs up user for desired event
    try {
      $dbh = connectDB();
      
      $statement = $dbh->prepare("Select count(*) from Joins where id = :id");
      $statement->bindParam(":id", id);
      $result1 = $statment->execute();
      
      $statement = $dbh->prepare("Select slots from Event where id = :id");
      $statement->bindParam(":id", id);
      $result2 = $statement->execute();
      
      if($result1 == $result2){
        return "Event has no remaining slots";
      }
      
      $statement = $dbh->prepare("Select count(*) from Joins where id = :id and email = :email");
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
    catch (Exception $exception){
      echo 'Errors Occurred in Join_Event Function function.php';
      echo $exception->getMessage();
    }
  }

  function Get_Event_Attendees(int $id){
   //Returns list of attendees of particular event
    try{
      $dbh = connectDB();
      $statement = $dbh->prepare("Select * from Joins where id = :id");
      $statement->bindParam(":ud", id);
      $result = $statement->execute();
      return $result;
    } 
    catch (Exception $exception){
      echo 'Errors Occurred in Get_Event_Attendees Function function.php';
      echo $exception->getMessage();
    }
  }

  function Create_User(String $email, String $password, String $name, String $intro, String $contact, int $admin){
    //creates user in DB 
    try {
      $dbh = connectDB();
      $statement = $dbh->prepare("SELECT count(*) from User where email = :email");
      $statement->bindParam(":email", email);
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

      $statement = $dbh->prepare("Select email, name, intro, contact, admin from User where email = :email");
      $statement->bindParam(":email", email);
      $result = $statement->execute();
      return $result;
      //return "Friend Created Successfully";
    } 
    catch (Exception $exception){
      echo 'Errors Occurred in Create_User Function function.php';
      echo $exception->getMessage();
    }
  }

  function Get_User(String $email){
    //Returns a given user
    try {
      $dbh = connectDB();
      $statement = $dbh->prepare("Select email, name, intro, contact from User where email = :email");
      $statement->bindParam(":email", email);
      $result = $statement->execute();
      return $result;
    } 
    catch (Exception $exception){
      echo 'Errors Occurred in Get_User Function function.php';
      echo $exception->getMessage();
    }
  }

  function Create_Event(String $email, String $title, String $description, int $slots, int $category, int $reported, String $date_created) {
   //creates event 
   try {
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
    catch (Exception $exception){
      echo 'Errors Occurred in Create_Event Function function.php';
      echo $exception->getMessage();
    }
  }

function Update_Event(int id, String param, String newVal){
  //Updates Event parameter param, sets to newVal
  try {
    $dbh = connectDB();
    $statement = $dbh->prepare("Update Event where id = :id set :param = :newVal");
    $statement->bindParam(":id", id);
    $statement->bindParam(":param", param);
    $statement->bindParam(":newVal", newVal);
    $result = $statement->execute();

    return $result;
  }
  
  catch (Exception $exception){
    echo 'Errors Occurred in Update_Event Function w/ String param function.php';
    echo $exception->getMessage();
  }
}

function Update_Event(int id, String param, int newVal){
//Updates Event parameter param, sets to newVal, same funcation, just takes input int
//rather than string for value
  try {
    $dbh = connectDB();
    $statement = $dbh->prepare("Update Event where id = :id set :param = :newVal");
    $statement->bindParam(":id", id);
    $statement->bindParam(":param", param);
    $statement->bindParam(":newVal", newVal);
    $result = $statement->execute();

    return $result;
  } 
  catch (Exception $exception){
    echo 'Errors Occurred in Update_Event Function w/ int param function.php';
    echo $exception->getMessage();
  }
}

?>
