<?php 
      
    // if(!isset($_SERVER['HTTP_REFERER'])){
    //     // redirect them to your desired location
    //     header('location: http://localhost/freshcery/index.php');
    //     exit;
    // }

      
    try {
        
        //host
        if (!defined('HOST')) define("HOST", getenv('DB_HOST') ?: "localhost");

        //dbname
        if (!defined('DBNAME')) define("DBNAME", getenv('DB_NAME') ?: "freshcery");

        //user
        if (!defined('USER')) define("USER", getenv('DB_USER') ?: "root");

        //pass
        if (!defined('PASS')) define("PASS", getenv('DB_PASS') !== false ? getenv('DB_PASS') : "");

        //port (external MySQL providers often use a non-3306 port)
        if (!defined('DBPORT')) define("DBPORT", getenv('DB_PORT') ?: "3306");


        $conn = new PDO("mysql:host=".HOST.";port=".DBPORT.";dbname=".DBNAME.";charset=utf8mb4", USER, PASS);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        // if($conn == true) {
        //     echo "connected successfully";
        // } else {
        //     echo "error";
        // }

    } catch (PDOException $e) {
        echo $e->getMessage();
    }