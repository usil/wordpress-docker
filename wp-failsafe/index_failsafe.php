<?php

function getSystemInfo() 
{       
    $operating_system = PHP_OS_FAMILY;
    if ($operating_system === 'Windows') return;

    $free = shell_exec('free');
    $free = (string)trim($free);
    $free_arr = explode("\n", $free);
    $mem = explode(" ", $free_arr[1]);
    $mem = array_filter($mem, function($value) { return ($value !== null && $value !== false && $value !== ''); }); // removes nulls from array
    $mem = array_merge($mem); // puts arrays back to [0],[1],[2] after 
    $memtotal = round($mem[1] / 1000000,2);
    $memused = round($mem[2] / 1000000,2);
    $memfree = round($mem[3] / 1000000,2);

    echo "<p style=\"text-align:center\">Ram(GB) total:$memtotal used:$memused free:$memfree</p>";

    $diskfree = round(disk_free_space(".") / 1000000000);
    $disktotal = round(disk_total_space(".") / 1000000000);
    $diskused = round($disktotal - $diskfree);
    $diskusage = round($diskused/$disktotal*100);    

    echo "<p style=\"text-align:center\">Disk(GB) total:$disktotal used:$diskused free:$diskfree</p>";
}

function validateMysqlConnection(){
    $conn = mysqli_connect(getenv('DB_HOST'), getenv('DB_USER'), getenv('DB_PASSWORD'), getenv('DB_NAME'));
    if (!$conn) {
        echo "<p style=\"text-align:center\">Connection failed: " . mysqli_connect_error()."</p>";
    }else{
        echo "<p style=\"text-align:center\">Mysql Connected successfully</p>";
    }        
}

function validateInternetAccess(){
    $host = 'www.google.com';
    $wait = 10;
    $fp = @fsockopen($host, 80, $errCode, $errStr, $wait);
    echo "<p style=\"text-align:center\">Ping $host:$port ($key) ==> ";
    if ($fp) {
        echo 'SUCCESS</p>';
        fclose($fp);
    } else {
        echo "ERROR: $errCode - $errStr</p>";
    }
}

validateMysqlConnection();
validateInternetAccess();
getSystemInfo();

echo phpinfo();
