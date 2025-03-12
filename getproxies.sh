#!/bin/bash

echo "Downloading 500 proxies from geonode.."
curl -s "https://proxylist.geonode.com/api/proxy-list?limit=500&page=1&sort_by=lastChecked&sort_type=desc" > /tmp/proxies

echo "Parsing IPs and ports (into file: proxies.txt).."
cat /tmp/proxies | jq --unbuffered -r '.data[] | .protocols[0] + " " + .ip + " " + .port' > /tmp/proxyportlist

echo "Testing proxies and saving results (into file: testerproxy).." > /tmp/testerproxy  # Crea o svuota il file testerproxy

# Funzione per testare un proxy
test_proxy() {
    local protocol="$1"
    local ip="$2"
    local port="$3"
    local proxy="$ip:$port"

    # Testa il proxy
    RES=$(curl -s --proxy "$protocol://$proxy" --connect-timeout 5 "http://httpbin.org/ip" 2> /dev/null)
    if [ -n "$RES" ]; then
        latency=$(curl -s -o /dev/null -w "%{time_total}" --proxy "$protocol://$proxy" --connect-timeout 5 "http://httpbin.org/ip")
        latency_ms=$(echo "$latency * 1000" | bc)
        if (( $(echo "$latency_ms < 1200" | bc -l) )); then
            echo "found: $protocol $ip $port"
            echo "$protocol $ip $port" >> proxies.txt
        fi
    fi
}

export -f test_proxy

# Usa xargs per eseguire test_proxy in parallelo
cat /tmp/proxyportlist | xargs -P 10 -I {} bash -c 'test_proxy $(echo {} | tr " " "\n")'

rm /tmp/proxies
rm /tmp/proxyportlist

echo "Proxy testing complete. Results saved in proxies.txt."
