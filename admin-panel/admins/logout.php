<?php 

    session_start();
    session_unset();
    session_destroy();

    $base = rtrim(getenv('APP_URL') ?: getenv('RENDER_EXTERNAL_URL') ?: "http://localhost/freshcery", '/');
    echo "<script> window.location.href='".$base."/admin-panel/admins/login-admins.php'; </script>";
