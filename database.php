<?php
// Content of database.php

$mysqli = new mysqli('localhost', 'Winston', 'Ch112211!', 'Hack23');

if($mysqli->connect_errno) {
	printf("Connection Failed: %s\n", $mysqli->connect_error);
	exit;
}
?>