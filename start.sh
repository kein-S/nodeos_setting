#!/bin/bash
DIR=$PWD

echo -e "Starting Nodeos \n";


if [ ! -d $DIR/data ]; then
   mkdir $DIR/data
fi


if [ ! -d $DIR/wallet ]; then
   mkdir $DIR/wallet
fi

nodeos --data-dir $DIR/data --config-dir $DIR/config --filter-on='*' "$@" > $DIR/stdout.txt 2> $DIR/stderr.txt &  echo $! > $DIR/nodeos.pid

