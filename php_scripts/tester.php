<?php
// Runs an unchecked SQL query
// VERY INSECURE - ONLY USE FOR TESTING, REMOVE FROM SERVER IN FINAL VERSION

// If these headers aren't here, Flutter errors in making the POST request
header("Access-Control-Allow-Headers: Authorization, Content-Type");
header("Access-Control-Allow-Origin: *");
header('content-type: application/json; charset=utf-8');

$data = json_decode(file_get_contents('php://input'), true);

$query = $data["query"];
$fetch = $data["fetch"] == "true";

function connectDB(){
    //Initializes database
    $config = parse_ini_file("db.ini");
    $dbh = new PDO($config["dsn"], $config["username"], $config["password"]);
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    return $dbh;
}

try {
    $dbh = connectDB();

    $statement = $dbh->prepare($query);

    $statement->execute();

    if (!$fetch) {
        $dbh = null;
        die();
    }

    $result = $statement->fetchAll(PDO::FETCH_ASSOC);

    $dbh = null;

    if (count($result) == 1) {
        echo json_encode($result[0]);
        die();
    }

    echo json_encode($result);
} catch (PDOException $e) {
    echo $e->getMessage();
}

?>