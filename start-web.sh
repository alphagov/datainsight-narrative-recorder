#!/usr/bin/env bash

set -e

echo -e "Starting application server"
bundle exec unicorn --port $PORT
