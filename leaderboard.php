<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Leaderboard</title>
    <link rel="stylesheet" type="text/css" href="leaderboard.css">
</head>

<body>
    <img src="alien.png" alt="Alien" id="upper-left-image">
    <img src="stars.png" alt="Stars" id="buttom-left-image">
    <h1>Leaderboard</h1>
    <img src="ufo.png" alt="UFO" id="upper-right-image">
    <img src="planet.png" alt="Planet" id="buttom-right-image">


    <?php
    require "database.php";

    // Handle POST request to insert data
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $username = $_POST["username"];
        $score = $_POST["score"];

        // Insert data into the database
        $insertQuery = "INSERT INTO leaderboard (username, score) VALUES (?, ?)";
        $stmt = $mysqli->prepare($insertQuery);
        $stmt->bind_param("si", $username, $score);

        if ($stmt->execute()) {
            echo "Data inserted successfully!";
        } else {
            echo "Error: " . $stmt->error;
        }

        $stmt->close();
    }

    // Retrieve all data from the database
    $selectQuery = "SELECT username, score FROM leaderboard ORDER BY score DESC";
    $result = $mysqli->query($selectQuery);

    if ($result->num_rows > 0) {
        echo '<table>
            <tr>
                <th>Username</th>
                <th>Score</th>
            </tr>';

        while ($row = $result->fetch_assoc()) {
            echo "<tr><td>" . $row["username"] . "</td><td>" . $row["score"] . "</td></tr>";
        }

        echo '</table>';
    } else {
        echo "No data found.";
    }

    $mysqli->close();
    ?>
</body>

</html>