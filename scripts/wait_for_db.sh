#!/bin/bash

echo "--- Waiting 15 seconds for database to start up..."

sleep 15

echo "--- Running command..."

eval "$@"
