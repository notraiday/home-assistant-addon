#!/bin/sh
set -e

# the server image's entrypoint preloads jemalloc, and the server reads log_level and
# safe_mode from the App options itself
exec /usr/local/bin/entrypoint.sh --data-dir /data --cache-dir /data/.cache
