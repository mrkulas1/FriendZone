<?php
// Hold declarations for all database communication functions that can be called
// by Flutter. For now, this will be user authentication, getting a list of events (basic data),
// and getting detailed info about one event.

function connectDB()
{
    //Initializes database
    $config = parse_ini_file("db.ini");
    $dbh = new PDO($config["dsn"], $config["username"], $config["password"]);
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    return $dbh;
}

function errorReturn(String $message)
{
    return array("error" => $message);
}

function getToken(String $email, String $password) {
    try {
        $dbh = connectDB();
        $authResult = Auth($email, $password);
        if ($authResult != 0) {
            $dbh = null;
            return errorReturn("Failed to get token, bad authentication");
        }

        // Purge out-of-date tokens
        $statement = $dbh->prepare("DELETE FROM Tokens WHERE expires < NOW()");
        $statement->execute();

        $randnum = rand();
        $time30min = time() + 1800;
        $timestr = date("Y-m-d H:i:s", $time30min);

        $statement = $dbh->prepare("INSERT INTO Tokens VALUES(:email, SHA2(:num, 256), :time)");
        $statement->bindParam(":email", $email);
        $statement->bindParam(":num", $randnum);
        $statement->bindParam(":time", $timestr);
        $statement->execute();

        $dbh = null;

        $token = hash("sha256", "$randnum");
        return array("token" => $token);
    } catch (PDOException $e) {
        return errorReturn($e->getMessage());
    }
}

function checkToken(String $token, String $email) {
    try {
        $dbh = connectDB();
        // Check that the token exists and is unexpired
        $statement = $dbh->prepare("SELECT COUNT(*) FROM Tokens WHERE email = :email AND token = :token AND expires > NOW()");
        $statement->bindParam(":email", $email);
        $statement->bindParam(":token", $token);
        $statement->execute();
        $row = $statement->fetch();

        if ($row[0] != 1) {
            $dbh = null;
            return false;
        }

        // Set the token to expire 30 minutes from now
        $time30min = time() + 1800;
        $timestr = date("Y-m-d H:i:s", $time30min);

        $statement = $dbh->prepare("UPDATE Tokens SET expires = :time WHERE token = :token");
        $statement->bindParam(":time", $timestr);
        $statement->bindParam(":token", $token);
        $statement->execute();

        $dbh = null;
        return true;
    } catch (PDOException $e) {
        return false;
    }
}

function eliminateSpaces($str)
{

    return trim($str);
}

/*
Return Codes:
0 - Success
1 - User DNE
2 - Wrong Password
3 - Locked Out
4 - Error
 */
function Auth(String $email, String $password)
{
    //Authenticates User for login function
    try {
        $dbh = connectDB();
        $email = trim($email, " ");
        // Determine whether user exists
        $statement = $dbh->prepare("SELECT count(*), IF(IFNULL(TIMESTAMPDIFF(MINUTE, lock_time, now()) < 15, 0), 1, 0) locked_out, login_attempts FROM User WHERE email = :email");
        $statement->bindParam(":email", $email);
        $result = $statement->execute();
        $row = $statement->fetch();

        //User doesn't exist
        if ($row[0] == 0) {
            $dbh = null;
            return 1;
        }

        //If the user is locked out
        if($row[1] == 1)
        {
            $dbh = null;
            return 3;
        }
        $login_attempts = $row[2];

        // Determine that the password is correct
        $statement = $dbh->prepare("select count(*) from User where email = :email and password = sha2(:password, 256)");
        $statement->bindParam(":email", $email);
        $statement->bindParam(":password", $password);
        $result = $statement->execute();
        $row = $statement->fetch();

        //Incorrect Login
        if ($row[0] == 0) {
            //Lockout user or increment their attempts
            if($login_attempts >= 3)
            {
                $statement = $dbh->prepare("UPDATE User SET lock_time = now(), login_attempts = 0 WHERE email = :email");
                $statement->bindParam(":email", $email);
                $result = $statement->execute();
                $dbh = null;
                return 3;
            }
            else
            {
                $statement = $dbh->prepare("UPDATE User SET login_attempts = login_attempts + 1 WHERE email = :email");
                $statement->bindParam(":email", $email);
                $result = $statement->execute();
                $dbh = null;
            }
            return 2;
        }

        //Reset attempts on correct login
        $statement = $dbh->prepare("UPDATE User SET login_attempts = 0 WHERE email = :email");
        $statement->bindParam(":email", $email);
        $result = $statement->execute();
        $dbh = null;
        return 0;
    } catch (PDOException $exception) {
        //echo 'Errors Occurred in Auth Function function.php';
        //echo $exception->getMessage();
        return 4;
    }
}

function Get_Cur_User(String $email)
{
    //Returns the user info from the user with the given email
    try {
        $dbh = connectDB();
        $email = trim($email, " ");
        $statement = $dbh->prepare("SELECT email, name, introduction, additional_contact, admin from User where email = :email");
        $statement->bindParam(":email", $email);
        $result = $statement->execute();
        $row = $statement->fetch(PDO::FETCH_ASSOC);

        $dbh = null;

        if (empty($row)) {
            return errorReturn("No user with this email");
        }

        return $row;
    } catch (PDOException $exception) {
        return errorReturn($exception->getMessage());
    }
}

function Create_User(String $email, String $password, String $name, String $intro, String $contact)
{
    //Creates user in DB, then return that user
    try {
        $dbh = connectDB();
        if (strlen($email) <= strlen("@mtu.edu")) {
            return errorReturn("User Needs Valid MTU Email");
        }
        $email = trim($email, " ");
        $statement = $dbh->prepare("SELECT count(*) from User where email = :email");
        $statement->bindParam(":email", $email);
        $result = $statement->execute();
        $row = $statement->fetch();

        if ($row[0] > 0) {
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

        return Get_Cur_User($email);
    } catch (PDOException $exception) {
        return errorReturn($exception->getMessage());
    }
}

function Get_Friends()
{
    //Returns list of friends with desired information
    //such as name, email, registered events with the exception of password
    try {
        $dbh = connectDB();
        $statement = $dbh->prepare("Select email, name, introduction, additional_contact from User");
        $return = $statement->execute();

        $dbh = null;

        return $return;
    } catch (PDOException $exception) {
        echo 'Errors Occurred in Get_Friends Function function.php';
        echo $exception->getMessage();
    }

}

function Get_All_Events()
{
    // Returns list of events with the basic info
    // TODO: maybe filter these to only events that are in the future?
    try {
        $dbh = connectDB();

        $statement = $dbh->prepare("Select id, email, title, time, location, slots, category, subcategory from Event");
        $return = $statement->execute();
        $rows = $statement->fetchAll(PDO::FETCH_ASSOC);

        $dbh = null;

        return $rows;
    } catch (PDOException $exception) {
        return errorReturn($exception->getMessage());
    }
}

function Get_Detailed_Event(int $id)
{
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
    } catch (PDOException $exception) {
        return errorReturn($exception->getMessage());
    }
}

function Create_Event(String $email, String $title, String $description,
    String $time, String $location, int $slots, String $category, String $subcategory) {
    //creates event, then returns its detailed info
    // NOTE - Commenting out time for now since String - DATETIME will be weird
    try {
        $dbh = connectDB();

        $statement = $dbh->prepare("INSERT INTO Event(email, title, description, time, location, slots, category, subcategory)
        values(:email, :title, :description, :time, :location, :slots, :category, :subcategory)");
        $statement->bindParam(":email", $email);
        $statement->bindParam(":title", $title);
        $statement->bindParam(":description", $description);
        $statement->bindParam(":time", $time);
        $statement->bindParam(":location", $location);
        $statement->bindParam(":slots", $slots);
        $statement->bindParam(":category", $category);
        $statement->bindParam(":subcategory", $subcategory);
        $result = $statement->execute();

        // This is potentially prone to error - need testing,
        // probably want to wrap in transaction to avoid race condition
        $statement = $dbh->prepare("SELECT max(id) from Event");
        $result = $statement->execute();
        $eventID = ($statement->fetch())[0];

        $dbh = null;
        return Get_Detailed_Event($eventID);
    } catch (PDOException $exception) {
        return errorReturn($exception->getMessage());
    }
}

// Making this to quickly throw something together
function Update_Event(int $id, String $title, String $description,
    String $time, String $location, int $slots, String $category, String $subcategory) {

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
            time = :time, location = :location, slots = :slots, category = :category,
            subcategory = :subcategory WHERE id = :id");
        $statement->bindParam(":id", $id);
        $statement->bindParam(":title", $title);
        $statement->bindParam(":description", $description);
        $statement->bindParam(":time", $time);
        $statement->bindParam(":location", $location);
        $statement->bindParam(":slots", $slots);
        $statement->bindParam(":category", $category);
        $statement->bindParam(":subcategory", $subcategory);
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

function Join_Event(int $id, String $email, String $comment)
{
    try {
        $dbh = connectDB();

        $statement = $dbh->prepare("SELECT Count(id) FROM Joins WHERE id = :id AND email = :email");
        $statement->bindParam(":id", $id);
        $statement->bindParam(":email", $email);
        $statement->execute();
        $result = $statement->fetchColumn(0);

        // Check if user already sign up for an event
        if ($result > 0) {
            $statement = $dbh->prepare("UPDATE Joins set comment = :comment WHERE id = :id AND email = :email");
            $statement->bindParam(":id", $id);
            $statement->bindParam(":email", $email);
            $statement->bindParam(":comment", $comment);
            $statement->execute();
            return 1; // Updated Event Comment
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
        if ($result1 == $result2) {
            return errorReturn("Event has no remaining slots");
        } else {
            $statement = $dbh->prepare("INSERT INTO Joins values(:id, :email, :comment)");
            $statement->bindParam(":id", $id);
            $statement->bindParam(":email", $email);
            $statement->bindParam(":comment", $comment);
            $statement->execute();
            return 1; //Event joined successfully
        }
    } catch (PDOException $exception) {
        //echo 'Errors Occurred in Join_Event Function function.php';
        return errorReturn($exception->getMessage());
    }
}

function Leave_Event(int $id, String $email)
{
    try {
        $dbh = connectDB();

        $statement = $dbh->prepare("SELECT Count(*) From Joins WHERE id = :id AND email = :email");
        $statement->bindParam(":id", $id);
        $statement->bindParam(":email", $email);
        $statement->execute();
        $result = $statement->fetchColumn(0);
        // Check if user is signed up to the event

        if($result == 0){
            return 1;
        }

        $statement = $dbh->prepare("DELETE FROM Joins WHERE id = :id AND email = :email");
        $statement->bindParam(":id", $id);
        $statement->bindParam(":email", $email);
        $result = $statement->execute();
        return 1; //"Event leave successfully";
    } catch (PDOException $exception) {
        //echo 'Errors Occurred in Leave_Event Function function.php';
        return errorReturn($exception->getMessage());
    }
}

function Get_Event_Attendees(int $id)
{
    //Returns list of attendees of particular event
    try {
        $dbh = connectDB();
        $statement = $dbh->prepare("SELECT email, name, introduction, additional_contact FROM User NATURAL JOIN Joins WHERE id = :id");
        $statement->bindParam(":id", $id);
        $statement->execute();
        $rows = $statement->fetchAll(PDO::FETCH_ASSOC);

        $dbh = null;

        return $rows;
    } catch (PDOException $exception) {
        //echo 'Errors Occurred in Get_Event_Attendees Function function.php';
        return errorReturn($exception->getMessage());
    }
}

function Get_My_Events(String $email)
{
    //Returns the events registered under a given user email
    try {
        $dbh = connectDB();
        $statement = $dbh->prepare("SELECT * FROM Event WHERE email = :email");
        $statement->bindParam(":email", $email);
        $result = $statement->execute();
        $rows = $statement->fetchAll(PDO::FETCH_ASSOC);

        $dbh = null;

        if (empty($rows)) {
            return errorReturn("User hasn't created any events");
        }

        return $rows;
    } catch (PDOException $exception) {
        return errorReturn($exception->getMessage());
    }
}

function Get_Joined_Events(String $email)
{
    //Returns events that a user has joined
    try {
        $dbh = connectDB();
        $statement = $dbh->prepare("SELECT e.id id, e.email email, title, description, time, location, slots, category, reported, date_created FROM Joins j JOIN Event e WHERE e.id = j.id && j.email = :email");
        $statement->bindParam(":email", $email);
        $result = $statement->execute();
        $rows = $statement->fetchAll(PDO::FETCH_ASSOC);

        $dbh = null;

        if (empty($rows)) {
            return errorReturn("User hasn't registered for any events");
        }

        return $rows;
    } catch (PDOException $exception) {
        return errorReturn($exception->getMessage());
    }
}

function Update_Profile(String $email, String $introduction, String $additional_contact)
{
    //email, password, name, introduction, additional_contact, admin
    try {
        $dbh = connectDB();

        $statement = $dbh->prepare("UPDATE User SET introduction = :introduction, additional_contact = :additional_contact WHERE email = :email");
        $statement->bindParam(":introduction", $introduction);
        $statement->bindParam(":additional_contact", $additional_contact);
        $statement->bindParam(":email", $email);
        $result = $statement->execute();

        $dbh = null;

        return Get_Cur_User($email);
    } catch (PDOException $exception) {
        return errorReturn($exception->getMessage());
    }
}

function Report_Event(int $id, String $email, String $comment)
{
    try {
        $dbh = connectDB();

        $statement = $dbh->prepare("SELECT Count(id) FROM Reports WHERE id = :id AND email = :email");
        $statement->bindParam(":id", $id);
        $statement->bindParam(":email", $email);
        $statement->execute();
        $result = $statement->fetchColumn(0);

        // Check if user already report an event
        if ($result > 0) {
            $statement = $dbh->prepare("UPDATE Reports set comment = :comment WHERE id = :id AND email = :email");
            $statement->bindParam(":id", $id);
            $statement->bindParam(":email", $email);
            $statement->bindParam(":comment", $comment);
            $statement->execute();
            return 1; // Updated Reported Comment
        }

        $statement = $dbh->prepare("INSERT INTO Reports values(:id, :email, :comment)");
        $statement->bindParam(":id", $id);
        $statement->bindParam(":email", $email);
        $statement->bindParam(":comment", $comment);
        $statement->execute();

        return 1; // Event reported successfully
    } catch (PDOException $exception) {
        return errorReturn($exception->getMessage());
    }
}

function Get_Foreign_User(String $email)
{
    //Returns the user info from the user with the given email
    try {
        $dbh = connectDB();
        $email = trim($email, " ");
        $statement = $dbh->prepare("SELECT email, name, introduction, additional_contact from User where email = :email");
        $statement->bindParam(":email", $email);
        $result = $statement->execute();
        $row = $statement->fetch(PDO::FETCH_ASSOC);

        $dbh = null;

        if (empty($row)) {
            return errorReturn("No user with this email");
        }

        return $row;
    } catch (PDOException $exception) {
        return errorReturn($exception->getMessage());
    }
}

function Delete_Event(int $id) {
    try{

    //return errorReturn("We made it here function start");

    $dbh = connectDB();
    $statement = $dbh->prepare("DELETE FROM Event WHERE id = :id");
    $statement->bindParam(":id", $id);
    $statement->execute();
    $dbh = null;

    return 1;

    } catch (PDOException $exception){
        return errorReturn($exception->getMessage());
    }
}

function Get_All_Reported_Event()
{
    // Returns list of reported event
    try {
        $dbh = connectDB();

        $statement = $dbh->prepare("SELECT DISTINCT e.id id, e.email email, title, description, time, location, slots, category, reported, date_created FROM Reports j JOIN Event e WHERE e.id = j.id");
        $return = $statement->execute();
        $rows = $statement->fetchAll(PDO::FETCH_ASSOC);

        $dbh = null;

        return $rows;
    } catch (PDOException $exception) {
        return errorReturn($exception->getMessage());
    }
}

function get_report_comment(int $id)
{
    try {
        $dbh = connectDB();

        $statement = $dbh->prepare("SELECT comment FROM Reports WHERE id = :id");
        $statement->bindParam(":id", $id);
        $return = $statement->execute();
        $row = $statement->fetchAll(PDO::FETCH_ASSOC);

        $dbh = null;

        return $row;

    } catch (PDOException $exception) {
        return errorReturn($exception->getMessage());
    }
}

function Get_Notifications(String $email)
{
    try {
        $dbh = connectDB();

        $dbh = null;

        return array();
    } catch (PDOException $exception) {
        return errorReturn($exception->getMessage());
    }
}
?>