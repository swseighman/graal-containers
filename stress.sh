#!/usr/bin/env bash

GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Create my files for storing the stats in
rm -f JDK_95.txt JDK_ALL_95.txt
touch JDK_95.txt JDK_ALL_95.txt

# Let's stress test and get some stats
echo -ne "Stress Testing..."

hey -z 15s -c 4 http://localhost:8081/jibber | tee JDK_ALL_95.txt | grep --color=auto -Eo '95% in [0-9]+.[0-9]+ secs' > JDK_95.txt &

# Progress bar
for i in `seq 16`;
    do echo -ne "#";
    sleep 1s;
done
echo -ne " DONE"
echo

JDK_LAT=`cat JDK_95.txt | sed 's/95% in //' | sed 's/ secs//' | awk '{printf "%d", $1*1000}'`
JDK_REQS=`cat JDK_ALL_95.txt | grep -Eo '[[:space:]]+Requests/sec:[[:space:]][0-9]+.[0-9]+' | awk '{print $2}'`

echo "JDK-Container ${JDK_LAT}" \
    | termgraph --title "Latency of 95% of Requests" --width 60 --color {green,} --suffix " ms"
echo

echo "# Requests / second"
echo -e "JDK-Container  ${GREEN}${JDK_REQS}${NC} req / s"
echo
