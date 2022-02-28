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
        
        break;
    
    case Functions::GET_USER:
        
        break;
    
    case Functions::CREATE_USER:
        
        break;
    
    case Functions::GET_ALL_EVENTS:
        
        break;
    
    case Functions::GET_DETAILED_EVENT:
    
        break;
    
    case Functions::CREATE_EVENT:
        
        break;
    
    case Functions::JOIN_EVENT:
        
        break;

    default:
        // If no function specified, error
        die();
}

?>