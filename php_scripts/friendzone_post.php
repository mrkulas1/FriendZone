<?php
// MAKE SURE THIS ENUM IS ALWAYS IN THE SAME ORDER AS THE ONE IN 
// make_post.dart!!
enum Functions: int
{
    case AUTH = 0;
    case GET_USER = 1;
    case CREATE_USER = 2;
    
    case GET_ALL_EVENTS = 3;
    case GET_DETAILED_EVENT = 4;
    case CREATE_EVENT = 5;
    
    case JOIN_EVENT = 6;    
}

// Main entry point for a Flutter page to make a POST request. The Flutter code
// will post a function ID, and some parameters through JSON. This script will
// call the relevant function, check that all parameters exist, and call the function
// Return status code ??? on failure, echo response JSON data on success

require "functions.php";

// If these headers aren't here, Flutter errors in making the POST request
header("Access-Control-Allow-Headers: Authorization, Content-Type");
header("Access-Control-Allow-Origin: *");
header('content-type: application/json; charset=utf-8');

// Get user input data into an associative array
$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data["functionID"])) {
    die();
    // Figure out how to return specific HTTP error code?
}

// Get the function to call
$functionID = $data["functionID"];


// Based on ID, call the function
switch ($functionID) {
    case Functions::AUTH:
        //Get input from POST Request
        $e = $data["email"];
        $p = $data["password"];
        //Output Auth function performed upon input
        return Auth($e, $p);
        break;
    
    case Functions::GET_USER:
        //Get input from POST Request
        $e = $data["email"];
        //Output specified user based upon input data
        return Get_User($e);
        break;
    
    case Functions::CREATE_USER:
        //Received input from POST Request and taken as variables
        $e = $data["email"];
        $p = $data["password"];
        $n = $data["name"];
        $i = $data["intro"];
        $c = $data["contact"];
        $a = $data["admin"];
        //Performs and outputs Create_User Function
        return Create_User($e, $p, $n, $i, $c, $a);
        break;
    
    case Functions::GET_ALL_EVENTS:
        //Return Get_All_Events Function
        return Get_All_Events();
        break;
    
    case Functions::GET_DETAILED_EVENT:
        //Takes POST input and outputs further details of the request
        $i = $data["id"];
        return Get_Detailed_Event($i);
        break;
    
    case Functions::CREATE_EVENT:
        //Takes POST input and assigns data to variables
        $e = $data["eventID"];
        $t = $data["title"];
        $d = $data["description"];
        $s = $data["slots"];
        $c = $data["category"];
        $r = $data["reported"];
        $date = $data["date_created"];
        //Variables input to Create_Event function, performed, and returned
        return Create_Event($e, $t, $d, $s, $c, $r, $date);
        break;
    
    case Functions::JOIN_EVENT:
        //Receives POST input and assigns to variables
        $i = $data["id"];
        $e = $data["email"];
        $c = $data["comment"];
        //Returns and performs Join_Event function
        return Join_Event($i, $e, $c);
        break;

    default:
        // If no function specified, error
        die();
}

?>