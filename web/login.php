<?php
// Enable error reporting
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Connect to SQLite database
try {
    $db = new SQLite3('/var/www/html/database.db');
} catch (Exception $e) {
    die("Cannot connect to database: " . $e->getMessage());
}

// Get the input values
$username = $_POST['username'];
$password = $_POST['password'];

// Create and execute the query
$query = "SELECT * FROM users WHERE username = '$username' AND password = '$password'";
$result = $db->query($query);

// Check if a row was returned
if ($result->fetchArray()) {
    echo "Flag: flag{web_exploitation_success}";
} else {
    echo "Invalid credentials.";
}
?>
