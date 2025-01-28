#!/bin/bash
crond -b -l 2
nginx

exec "$@"