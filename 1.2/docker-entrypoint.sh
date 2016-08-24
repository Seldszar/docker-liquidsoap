#!/bin/bash
set -e

if [ "$1" = 'liquidsoap' ]; then
    eval $(gosu liquidsoap opam config env)
    exec gosu liquidsoap "$@"
fi

exec "$@"
