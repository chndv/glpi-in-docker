#!/bin/bash
crond -b
nginx

exec "$@"