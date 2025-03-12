#!/bin/sh

echo "Downloading 50 proxies from geonode.."
curl -s "https://proxylist.geonode.com/api/proxy-list?limit=50&page=1&sort_by=lastChecked&sort_type=desc" > proxies

echo "Parsing IPs and ports (into file: proxyportlist).."
cat proxies | jq --unbuffered -r '.data[] | .protocols[0] + " " + .ip + " " + .port' > proxyportlist

echo "Testing proxies and saving results (into file: testerproxy).."
> testerproxy  # Crea o svuota il file testerproxy

while IFS=' ' read -r protocol ip port; do
    proxy="$ip:$port"
    # Testa il proxy
    if curl -s --proxy "$protocol://$proxy" --connect-timeout 5 "http://httpbin.org/ip" > /dev/null; then
        echo "$protocol $ip $port" >> proxies-ok.txt
    else
        echo "$protocol $ip $port" >> proxies-ok.txt
    fi
done < proxyportlist

rm testerproxy
rm proxies
rm proxyportlist

echo "Proxy testing complete. Results saved in testerproxy."
