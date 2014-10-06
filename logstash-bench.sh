#!/bin/sh

#### Set starting point - only enable 3 CPUs and 1 logstash worker ####
echo -n `date +%H:%M`" "; echo -n "Setting stating point... "
for i in {3..5}; do `echo 0 > /sys/devices/system/cpu/cpu$i/online`; done
/bin/sed -i.bkp 's/LS_OPTS=.*/LS_OPTS=\"-w 1\"/g' /etc/rc.d/init.d/logstash
/usr/bin/systemctl daemon-reload
echo "Done!"


#### Start logstash ####
echo -n `date +%H:%M`" "; echo -n "Testing with 3 CPUs and 1 worker... "
/usr/bin/systemctl start logstash
echo "Now!"
sleep 10m
# Get some statistics
(echo -n "Test scenario #"$1": "$2" - 1 worker events rate: "; tail /var/log/logstash/logstash.stdout | grep "events.rate_1m" | awk '{print $3}') >> /root/logstash.bench


#### After 10min, add another CPU and worker and restart logstash ####
echo -n `date +%H:%M`" "; echo -n "Testing with 4 CPUs and 2 workers... "
echo 1 > /sys/devices/system/cpu/cpu3/online
/bin/sed -i.bkp 's/LS_OPTS=.*/LS_OPTS=\"-w 2\"/g' /etc/rc.d/init.d/logstash
/usr/bin/systemctl daemon-reload
/usr/bin/systemctl restart logstash
echo "Now!"
sleep 10m
# Get some statistics
(echo -n "Test scenario #"$1": "$2" - 2 worker events rate: "; tail /var/log/logstash/logstash.stdout | grep "events.rate_1m" | awk '{print $3}') >> /root/logstash.bench


#### After 10min, add 2 CPUs and 2 workers and reset logstash ####
echo -n `date +%H:%M`" "; echo -n "Testing with 6 CPUs and 4 workers... "
echo 1 > /sys/devices/system/cpu/cpu4/online
echo 1 > /sys/devices/system/cpu/cpu5/online
/bin/sed -i.bkp 's/LS_OPTS=.*/LS_OPTS=\"-w 4\"/g' /etc/rc.d/init.d/logstash
/usr/bin/systemctl daemon-reload
/usr/bin/systemctl restart logstash
echo "Now!"
sleep 10m
# Get some statistics
(echo -n "Test scenario #"$1": "$2" - 4 worker events rate: "; tail /var/log/logstash/logstash.stdout | grep "events.rate_1m" | awk '{print $3}') >> /root/logstash.bench

#### After 30min, stop logstash ####
/usr/bin/systemctl stop logstash
echo -n `date +%H:%M`" "; echo "Benchmark finished"