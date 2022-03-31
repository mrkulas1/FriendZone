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
    const LEAVE_EVENT = 8;

    const GET_EVENT_USERS = 9;
    const GET_MY_EVENTS = 10;
    const GET_JOINED_EVENTS = 11;

    const UPDATE_PROFILE = 12;

    const REPORT_EVENT = 13;
}

// Main entry point for a Flutter page to make a POST request. The Flutter code
// will post a function ID, and some parameters through JSON. This script will
// call the relevant function, check that all parameters exist, and call the function

// Careful with response code 500 - Seems like Flutter sends a web request to check
// the domain before sending the data? Need to look into this more

require "functions.php";

function fail_notFound()
{
    http_response_code(404);
    die();
}

function fail_alreadyThere()
{
    http_response_code(409);
    die();
}

function fail_general()
{
    http_response_code(202);
    die();
}

function bulk_isset($params, $map)
{
    foreach ($params as $p) {
        if (!isset($map[$p])) {
            return false;
        }
    }
    return true;
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

        echo json_encode(array("status" => $code));
        break;

    case PHPFunctions::GET_USER:
        //Get input from POST Request
        if (!isset($data["email"])) {
            fail_general();
        }

        $e = $data["email"];
        //Output specified user based upon input data
        $user = Get_User($e);

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

        echo json_encode($user);
        break;

    case PHPFunctions::GET_ALL_EVENTS:
        //Return Get_All_Events Function
        $events = Get_All_Events();

        echo json_encode($events);
        break;

    case PHPFunctions::GET_DETAILED_EVENT:
        //Takes POST input and outputs further details of the request
        if (!isset($data["id"])) {
            fail_general();
        }

        $i = $data["id"];
        $event = Get_Detailed_Event($i);

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
        $event = Create_Event($e, $t, $d, $time, $l, $s, $c);

        echo json_encode($event);
        break;

    case PHPFunctions::UPDATE_EVENT:
        if (!bulk_isset(array("id", "title", "description",
            "location", "time", "slots", "category"), $data)) {
            fail_general();
        }

        $i = $data["id"];
        $t = $data["title"];
        $d = $data["description"];
        $l = $data["location"];
        $time = $data["time"];
        $s = $data["slots"];
        $c = $data["category"];

        //Variables input to Create_Event function, performed, and returned
        $event = Update_Event($i, $t, $d, $time, $l, $s, $c);

        echo json_encode($event);
        break;

    case PHPFunctions::JOIN_EVENT:
        if (!bulk_isset(array("id", "email", "comment"), $data)) {
            fail_general();
        }

        $i = $data["id"];
        $e = $data["email"];
        $c = $data["comment"];
        //Returns and performs Join_Event function
        $joined = Join_Event($i, $e, $c);

        if (isset($joined["error"])) {
            echo json_encode($joined);
        }

        echo json_encode(array("status" => $joined));
        break;

    case PHPFunctions::LEAVE_EVENT:
        if (!bulk_isset(array("id", "email"), $data)) {
            fail_general();
        }

        $i = $data["id"];
        $e = $data["email"];

        $left = Leave_Event($i, $e);

        if (isset($left["error"])) {
            echo json_encode($left);
        }

        echo json_encode(array("status" => $left));
        break;

    case PHPFunctions::GET_EVENT_USERS:
        if (!isset($data["id"])) {
            fail_general();
        }

        $id = $data["id"];

        $users = Get_Event_Attendees($id);

        echo json_encode($users);
        break;

    case PHPFunctions::GET_MY_EVENTS:
        //Return Get_My_Events Function
        if (!isset($data["email"])) {
            fail_general();
        }

        $i = $data["email"];
        $events = Get_My_Events($i);

        echo json_encode($events);
        break;

    case PHPFunctions::GET_JOINED_EVENTS:
        //Return Get_Joined_Events Function
        if (!isset($data["email"])) {
            fail_general();
        }

        $i = $data["email"];
        $events = Get_Joined_Events($i);

        echo json_encode($events);
        break;

    case PHPFunctions::UPDATE_PROFILE:
        if (!bulk_isset(array("email", "introduction", "additional_contact"), $data)) {
            fail_general();
        }

        $e = $data["email"];
        $i = $data["introduction"];
        $a = $data["additional_contact"];

        //Variables input to Create_Event function, performed, and returned
        $user = Update_Profile($e, $i, $a);

        echo json_encode($user);
        break;

    case PHPFunctions::REPORT_EVENT:
        if (!bulk_isset(array("id", "email", "comment"), $data)) {
            fail_general();
        }

        $i = $data["id"];
        $e = $data["email"];
        $c = $data["comment"];

        $report = Report_Event($i, $e, $c);

        if (isset($report["error"])) {
            echo json_encode($report);
        }

        echo json_encode(array("status" => $report));

        break;

    default:
        // If no function specified, error
        fail_general();
        break;
}

?>