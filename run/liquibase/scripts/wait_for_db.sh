#!/bin/bash

echo "--- Waiting 60 seconds for database to start up..."

sleep 60

echo "--- Running command..."

eval "$@"
