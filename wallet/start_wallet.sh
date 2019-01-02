#!/bin/bash
DIR=$PWD
WALLET_HOST="127.0.0.1"
WALLET_POSRT="3000"


$DIR/stop_wallet.sh
keosd --config-dir $DIR --wallet-dir $DIR --http-server-address $WALLET_HOST:$WALLET_POSRT $@ & echo $! > $DIR/wallet.pid
