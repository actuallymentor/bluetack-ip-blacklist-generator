sudo apt update && sudo apt install -y iprange # Comment this out if you have installed iprange
curl -s https://www.iblocklist.com/lists.php -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36" \
| grep -A 2 Bluetack \
| sed -n "s/.*value='\(http:.*\)'.*/\1/p" \
| xargs wget -O - \
| gunzip \
| egrep -v '^#' > blacklist
grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' blacklist > blacklist-ip
grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}[-][0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' blacklist > blacklist-ip-range
iprange blacklist-ip-range > blacklist-ip-cidr

sort blacklist-ip-cidr | grep -v '/' |uniq -u >> blacklist-ip # Here are added only single IP's from range file
sort blacklist-ip | uniq -u > blacklist-ip-sorted # Sort, check and remove duplicates
sort blacklist-ip-cidr | grep '/' |uniq -u > blacklist-ip-cidr-sorted # Here are only network segments, sorted and removed duplicates

while read IPADDR
do
    route add -net $IPADDR gw 127.0.0.1 lo &
done < blacklist-ip-cidr-sorted

while read IPADDR
do
    route add $IPADDR gw 127.0.0.1 lo &
done < blacklist-ip-sorted

rm blacklist-ip
rm blacklist-ip-sorted
rm blacklist-ip-range
rm blacklist-ip-cidr
rm blacklist-ip-cidr-sorted
