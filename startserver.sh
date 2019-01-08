sudo iptables -A INPUT -p tcp --dport 7777 -j ACCEPT
sudo kill -9 $(lsof -t -i:7777)
DreamDaemon polaris 7777 -trusted -webclient -public
