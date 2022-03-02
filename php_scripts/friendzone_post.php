<?php
// MAKE SURE THESE CONSTANTS ARE ALWAYS IN THE SAME ORDER AS THE ONE IN 
// make_post.dart!!

// Would be an enum, but those aren't supported in the PHP 7 on MTU servers
class PHPFunctions
{
    const AUTH = 0;
    const GET_USER = 1;
    const CREATE_USER = 2;
    
    const GET_ALL_EVENTS = 3;
    const GET_DETAILED_EVENT = 4;
    const CREATE_EVENT = 5;
    const UPDATE_EVENT = 6;
    
    const JOIN_EVENT = 7;    
}

// Main entry point for a Flutter page to make a POST request. The Flutter code
// will post a function ID, and some parameters through JSON. This script will
// call the relevant function, check that all parameters exist, and call the function

// Careful with response code 500 - Seems like Flutter sends a web request to check
// the domain before sending the data? Need to look into this more

require "functions.php";

function fail_notFound() {
    http_response_code(404);
    die();
}

function fail_alreadyThere() {
    http_response_code(409);
    die();
}

function fail_general() {
    http_response_code(204);
    die();
}

function bulk_isset($params, $map) {
    foreach($params as $p) {
        if (!isset($map[$p])) {
            return False;
        }
    }
    return True;
}

// If these headers aren't here, Flutter errors in making the POST request
header("Access-Control-Allow-Headers: Authorization, Content-Type");
header("Access-Control-Allow-Origin: *");
header('content-type: application/json; charset=utf-8');

// Get user input data into an associative array
$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data["functionID"])) {
    fail_general();
}

// Get the function to call
$functionID = $data["functionID"];

// Based on ID, call the function
switch ($functionID) {
    case PHPFunctions::AUTH:
        //Get input from POST Request
        if (!bulk_isset(array("email", "password"), $data)) {
            fail_general();
        }
        $e = $data["email"];
        $p = $data["password"];
        //Output Auth function performed upon input
        $code = Auth($e, $p);
        
        echo json_encode( array("status" => $code) );
        break;
    
    case PHPFunctions::GET_USER:
        //Get input from POST Request
        if (!isset($data["email"])) {
            fail_general();
        }

        $e = $data["email"];
        //Output specified user based upon input data
        $user = Get_User($e);
        
        if (isset($user["error"])) {
            if ($user["error"] == "No user with this email") {
                fail_notFound();
            }
            fail_general();
        }

        echo json_encode($user);
        break;
    
    case PHPFunctions::CREATE_USER:
        //Received input from POST Request and taken as variables
        if (!bulk_isset(array("email", "password", "name", "intro", "contact"), $data)) {
            fail_general();
        }

        $e = $data["email"];
        $p = $data["password"];
        $n = $data["name"];
        $i = $data["intro"];
        $c = $data["contact"];
        //Performs and outputs Create_User Function
        $user = Create_User($e, $p, $n, $i, $c);
        
        if (isset($user["error"])) {
            if ($user["error"] == "User Already Exists") {
                fail_alreadyThere();
            }
            fail_general();
        }

        echo json_encode($user);
        break;
    
    case PHPFunctions::GET_ALL_EVENTS:
        //Return Get_All_Events Function
        $events = Get_All_Events();
        
        if (isset($events["error"])) {
            fail_general();
        }

        echo json_encode($events);
        break;
    
    case PHPFunctions::GET_DETAILED_EVENT:
        //Takes POST input and outputs further details of the request
        if (!isset($data["id"])) {
            fail_general();
        }

        $i = $data["id"];
        $event = Get_Detailed_Event($i);
        
        if (isset($event["error"])) {
            if ($event["error"] == "No event with this ID") {
                fail_notFound();
            }
            fail_general();
        }
        
        echo json_encode($event);
        break;
    
    case PHPFunctions::CREATE_EVENT:
        //Takes POST input and assigns data to variables
        if (!bulk_isset(array("userEmail", "title", "description", 
            "location", "time", "slots", "category"), $data)) {
            fail_general();
        }
        $e = $data["userEmail"];
        $t = $data["title"];
        $d = $data["description"];
        $l = $data["location"];
        $time = $data["time"];
        $s = $data["slots"];
        $c = $data["category"];

        //Variables input to Create_Event function, performed, and returned
        $event = Create_Event($e, $t, $d, $time, $l, $s, $c, $r);
        
        if (isset($event["error"])) {
            if ($event["error"] == "No event with this ID") {
                fail_notFound();
            }
            fail_general();
        }

        echo json_encode($event);
        break;
    
    case PHPFunctions::UPDATE_EVENT:
        break;

    case PHPFunctions::JOIN_EVENT:
        //Receives POST input and assigns to variables
        $i = $data["id"];
        $e = $data["email"];
        $c = $data["comment"];
        //Returns and performs Join_Event function
        return Join_Event($i, $e, $c);
        break;

    default:
        // If no function specified, error
        fail_general();
        break;
}

?>