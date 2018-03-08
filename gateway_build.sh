#!/bin/bash

if [ \! -f mqtt_user ] ; then
	echo "mqtt_user file is missing"
	exit 1
fi
if [ \! -f mqtt_pass ] ; then
	echo "mqtt_pass file is missing"
	exit 1
fi

##
## Start of options
##

DEBUG_OPTS="--my-debug=enable"

STD_OPTS="--my-transport=nrf24 --my-gateway=mqtt --my-controller-ip-address=127.0.0.1 --my-port=1883"
#STD_OPTS="--my-transport=nrf24 --my-gateway=serial --my-controller-ip-address=127.0.0.1 --my-port=1883"

TOPIC_OPTS="--my-mqtt-publish-topic-prefix=pi-sensors-out --my-mqtt-subscribe-topic-prefix=pi-sensors-in"

ID_OPTS="--my-mqtt-client-id=pi-gateway --my-mqtt-user=$(cat mqtt_user) --my-mqtt-password=$(cat mqtt_pass)"

PIN_OPTS="--my-leds-err-pin=12 --my-leds-rx-pin=16 --my-leds-tx-pin=18 --my-rf24-irq-pin=15"
#PIN_OPTS="--my-leds-err-pin=12 --my-leds-rx-pin=16 --my-leds-tx-pin=18"

RF24_OPTS="--my-rf24-pa-level=RF24_PA_MAX --my-rf24-channel=124"
#RF24_OPTS="--my-rf24-pa-level=RF24_PA_MIN"

EXTRA_FLAGS="-DMY_RF24_DATARATE=\(RF24_1MBPS\)"

##
## End of options
##

echo "Running: systemctl stop mysgw.service"
sudo systemctl stop mysgw.service

echo "Executing: systemctl disable mysgw.service"
sudo systemctl disable mysgw.service

#make clean

./configure ${DEBUG_OPTS} ${STD_OPTS} ${TOPIC_OPTS} ${ID_OPTS} ${PIN_OPTS} ${RF24_OPTS} --extra-cxxflags="${EXTRA_FLAGS}"

make && sudo make install || exit -1

echo "Executing: systemctl enable mysgw.service"
sudo systemctl enable mysgw.service

echo "Executing: systemctl start mysgw.service"
sudo systemctl start mysgw.service
