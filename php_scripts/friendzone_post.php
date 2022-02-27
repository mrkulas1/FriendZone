<?php
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

if (!isset($data["funcationID"])) {
    die();
    // Figure out how to return specific HTTP error code?
}

// Get the function to call
$functionID = $data["functionID"];


// Based on ID, call the function

?>