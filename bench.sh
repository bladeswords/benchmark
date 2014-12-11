#!/bin/bash

# Based off https://github.com/mgutz/vpsbench/blob/master/vpsbench and http://freevps.us/downloads/bench.sh

#Gather system info
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
swap=$( free -m | awk 'NR==4 {print $2}' )
up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')
version=$(cat /etc/issue)
kernel=$(uname -a)

#Add local IP and internet IP
#Add number of network interfaces
#Add interface speed
echo "CPU model : $cname"
echo "Number of cores : $cores"
echo "CPU frequency : $freq MHz"
echo "Total amount of ram : $tram MB"
echo "Total amount of swap : $swap MB"
echo "System uptime : $up"
echo "System version: $version"
echo "System kernel: $kernel"

#Test disk IO
io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' && rm -f test_$$ )
echo "I/O speed : $io"

#echo -n "Benching CPU. Bzipping 25MB file: "
#dd if=/dev/urandom of=test_$$ bs=1024 count=25000 >>/dev/null 2>&1
#tf=$( (time tar cfj test_$$.bz2 $test_$$) 2>&1 | awk -F)
#rm -f test_$$*
#echo $tf

echo -n "Testing Network IO to RamNode New York City (USA): "
speed=$( wget -O /dev/null http://lg.nyc.ramnode.com/100MB.test   2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo $speed

echo -n "Testing Network IO to RamNode Atlanta (USA): "
speed=$( wget -O /dev/null http://lg.atl.ramnode.com/100MB.test   2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo $speed

echo -n "Testing Network IO to RamNode Seatle (USA): "
speed=$( wget -O /dev/null http://lg.sea.ramnode.com/100MB.test   2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo $speed

echo -n "Testing Network IO to RamNode Netherlands (NL): "
speed=$( wget -O /dev/null http://lg.nl.ramnode.com/100MB.test   2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo $speed

echo -n "Testing Network IO to Linode Tokyo (JP): "
speed=$( wget -O /dev/null http://speedtest.tokyo.linode.com/100MB-tokyo.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo $speed

echo -n "Testing Network IO to Softlayer Singapore (SG): "
speed=$( wget -O /dev/null http://speedtest.sng01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo $speed