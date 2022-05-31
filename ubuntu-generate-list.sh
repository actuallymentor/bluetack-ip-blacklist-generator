command -v iprange || sudo apt install -y iprange # Comment this out if you have installed iprange
curl -s https://www.iblocklist.com/lists.php -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36" \
| grep -A 2 Bluetack \
| sed -n "s/.*value='\(http:.*\)'.*/\1/p" \
| xargs wget -O - \
| gunzip \
| egrep -v '^#' > blacklist
grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' blacklist > blacklist-ip
grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}[-][0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' blacklist > blacklist-ip-range
iprange blacklist-ip-range > blacklist-ip-cidr

# Generate IP list
sort blacklist-ip-cidr | grep -v '/' |uniq -u >> blacklist-ip # Here are added only single IP's from range file
sort blacklist-ip | uniq -u > blacklist-ip-sorted # Sort, check and remove duplicates
sort blacklist-ip-cidr | grep '/' |uniq -u > blacklist-ip-cidr-sorted # Here are only network segments, sorted and removed duplicates

# Concat separate lists
cat blacklist-ip-cidr-sorted > blacklist
cat blacklist-ip-sorted >> blacklist

# Remove temp files
rm blacklist-ip
rm blacklist-ip-sorted
rm blacklist-ip-range
rm blacklist-ip-cidr
rm blacklist-ip-cidr-sorted

# Generate domain files
#while read IPADDR
#do
#    dig +short -x $IPADDR @127.0.0.1 >> blacklist-domains-raw
#done < blacklist
#sort blacklist-domains-raw | uniq -u > blacklist-domains # Sort, check and remove duplicates
#rm blacklist-domains-raw
