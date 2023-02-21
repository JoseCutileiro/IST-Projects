#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

rm -f send.dat receive.dat sender-packets.log receiver-packets.log
dd if=/dev/urandom of=send.dat bs=1000 count=20

LD_PRELOAD="./log-packets.so" \
  PACKET_LOG="sender-packets.log" \
  DROP_PATTERN="101010" \
  ./file-sender 1234 5 &
SENDER_PID=$!
sleep .1

pushd /tmp > /dev/null
  LD_PRELOAD="$SCRIPT_DIR/log-packets.so" \
    PACKET_LOG="receiver-packets.log" \
    DROP_PATTERN="00011" \
    $SCRIPT_DIR/file-receiver send.dat localhost 1234 1 || true
popd > /dev/null

wait $SENDER_PID || true

mv /tmp/send.dat receive.dat
mv /tmp/receiver-packets.log receiver-packets.log 

diff -qs send.dat receive.dat || true
rm send.dat receive.dat

./generate-msc.sh msc.eps sender-packets.log receiver-packets.log
rm sender-packets.log receiver-packets.log

